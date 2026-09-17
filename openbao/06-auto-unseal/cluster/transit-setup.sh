#!/bin/sh
# Field Note 6, transit seal: the VM OpenBao unseals the cluster OpenBao.
# Part A runs against the VM (bao login -method=userpass first).
# Part B changes the cluster chart values and migrates.
set -eu

# ── A: VM OpenBao (the unsealer) ────────────────────────────────────────
bao secrets enable -path=transit transit
bao write -f transit/keys/cluster-unseal
bao policy write cluster-unseal - <<'HCL'
path "transit/encrypt/cluster-unseal" { capabilities = ["update"] }
path "transit/decrypt/cluster-unseal" { capabilities = ["update"] }
HCL
# a periodic, orphan token: it must outlive whoever created it and renew
# itself on use - the cluster OpenBao uses it on every start
bao token create -policy=cluster-unseal -period=720h -orphan \
  -display-name=cluster-unseal -field=token > cluster-unseal.token
chmod 0600 cluster-unseal.token

# ── B: cluster OpenBao ──────────────────────────────────────────────────
# 1. the token as a Secret the pod can read (or via ExternalSecret from the
#    VM OpenBao - but not from the cluster OpenBao, it cannot unseal itself)
kubectl -n openbao create secret generic openbao-transit-token \
  --from-file=BAO_SEAL_TOKEN=cluster-unseal.token
rm cluster-unseal.token

# 2. helm/values.yaml: seal block + env from the Secret (see values-transit.yaml)
# 3. helm upgrade, delete the pod, then ONCE:
#    kubectl exec -n openbao openbao-0 -- bao operator unseal -migrate   # 3x Shamir keys
#    kubectl exec -n openbao openbao-0 -- bao status   # Seal Type transit, Recovery Seal true
# 4. delete the pod again: it must come back UNSEALED on its own
