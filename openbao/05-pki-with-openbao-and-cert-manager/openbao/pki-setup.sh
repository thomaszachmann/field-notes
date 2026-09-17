#!/bin/sh
# OpenBao side of Field Note 7: root CA, intermediate CA, role, policy,
# Kubernetes auth role for cert-manager. Run in a shell with a token that
# may manage mounts (root during bootstrap, admin afterwards).
set -eu
ADDR=${BAO_ADDR:-http://openbao.openbao.svc:8200}

# 1. root CA - key never leaves OpenBao
bao secrets enable -path=pki -max-lease-ttl=87600h pki
bao write pki/root/generate/internal \
  common_name="Homelab Root CA" issuer_name=root-2026 \
  key_type=ec key_bits=256 ttl=87600h
bao write pki/config/urls \
  issuing_certificates="$ADDR/v1/pki/ca" \
  crl_distribution_points="$ADDR/v1/pki/crl"

# 2. intermediate CA - CSR out, signed cert back in
bao secrets enable -path=pki_int -max-lease-ttl=43800h pki
bao write -field=csr pki_int/intermediate/generate/internal \
  common_name="Homelab Intermediate CA" key_type=ec key_bits=256 > /tmp/pki_int.csr
bao write -field=certificate pki/root/sign-intermediate \
  csr=@/tmp/pki_int.csr format=pem_bundle ttl=43800h issuer_ref=root-2026 > /tmp/pki_int.pem
bao write pki_int/intermediate/set-signed certificate=@/tmp/pki_int.pem
rm -f /tmp/pki_int.csr /tmp/pki_int.pem
bao write pki_int/config/urls \
  issuing_certificates="$ADDR/v1/pki_int/ca" \
  crl_distribution_points="$ADDR/v1/pki_int/crl"
# set-signed imports two issuers (the intermediate with its key, and a copy
# of the root without key); name the one with the key
INT=$(bao read -field=default pki_int/config/issuers)
bao write "pki_int/issuer/$INT" issuer_name=int-2026

# 3. role: what cert-manager may ask for
bao write pki_int/roles/cluster-internal \
  allowed_domains="svc.cluster.local,demo.svc,example.internal" \
  allow_subdomains=true allow_bare_domains=false allow_glob_domains=false \
  allow_ip_sans=false enforce_hostnames=true \
  key_type=ec key_bits=256 \
  ttl=720h max_ttl=2160h \
  server_flag=true client_flag=false require_cn=false

# 4. policy + auth role for cert-manager
bao policy write cert-manager - <<'HCL'
path "pki_int/sign/cluster-internal" { capabilities = ["create", "update"] }
HCL
bao write auth/kubernetes/role/cert-manager \
  bound_service_account_names=cert-manager-openbao \
  bound_service_account_namespaces=cert-manager \
  token_policies=cert-manager token_ttl=10m
