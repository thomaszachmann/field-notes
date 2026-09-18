#!/bin/sh
# Field Note 1 - every command, in order (Appendix A). Not meant to be run
# as a script: init and unseal are interactive on purpose. Copy line by
# line from here instead of from the PDF.
# Placeholders: <worker-ip>, <first-server-ip>, <cluster-token>.
exit 0

# ── Cluster (see "The cluster"; config files in rke2/) ───────────────
scp rke2/config-server-1.yaml root@<first-server>:/etc/rancher/rke2/config.yaml
curl -sfL https://get.rke2.io | sh -                       # on each server
systemctl enable --now rke2-server.service
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -   # on each worker
systemctl enable --now rke2-agent.service
apt-get update && apt-get install -y open-iscsi            # on each worker
systemctl enable --now iscsid
helm repo add longhorn https://charts.longhorn.io
helm upgrade --install longhorn longhorn/longhorn -n longhorn-system --create-namespace

# ── Helm ─────────────────────────────────────────────────────────────
helm repo add openbao https://openbao.github.io/openbao-helm
helm upgrade --install openbao openbao/openbao --version 0.29.4 \
  -n openbao --create-namespace -f k8s/values.yaml

# ── init / unseal (shell in the pod, normal terminal) ────────────────
kubectl exec -it -n openbao openbao-0 -- sh
bao operator init -key-shares=5 -key-threshold=3     # output -> password manager
bao operator unseal                                   # x3
bao status
read -rs BAO_TOKEN; export BAO_TOKEN                  # no 'bao login' in the pod

# ── Kubernetes auth ──────────────────────────────────────────────────
bao auth enable kubernetes
bao write auth/kubernetes/config kubernetes_host="https://kubernetes.default.svc:443"
bao write auth/kubernetes/role/demo \
  bound_service_account_names=demo bound_service_account_namespaces=demo \
  token_policies=default token_ttl=1h

# ── Hardening (keep the order) ───────────────────────────────────────
# audit: k8s/values-hardened.yaml (audit block + auditStorage), then:
kubectl delete sts -n openbao openbao                 # PVC stays (Retain)
helm upgrade --install openbao openbao/openbao --version 0.29.4 \
  -n openbao -f k8s/values.yaml -f k8s/values-hardened.yaml
bao operator unseal                                   # x3, then: bao audit list
bao policy write admin openbao/admin.hcl
bao auth enable userpass
bao write auth/userpass/users/admin password=... \
  token_policies=admin token_ttl=1h token_max_ttl=8h
ADMIN_TOKEN="$(bao login -method=userpass -token-only username=admin)"
BAO_TOKEN="$ADMIN_TOKEN" bao operator generate-root -init
BAO_TOKEN="$ADMIN_TOKEN" bao operator generate-root -cancel
bao token revoke -self                                # only after the test passed

# ── Snapshot by hand ─────────────────────────────────────────────────
kubectl exec -n openbao openbao-0 -- \
  sh -c 'bao operator raft snapshot save /tmp/bao.snap'
kubectl cp openbao/openbao-0:/tmp/bao.snap ./openbao-$(date +%Y%m%dT%H%M).snap
tar -xzOf openbao-*.snap state.bin | sha256sum
