#!/bin/sh
# OpenBao side of Field Note 8: OIDC auth against Keycloak, two roles,
# policies, Keycloak groups -> external groups -> policies. Run with a token
# that may manage auth methods and identity (root during bootstrap, admin
# afterwards). Needs the OpenBao root CA as /tmp/root.pem (Keycloak's TLS).
set -eu
KC=https://keycloak-service.keycloak.svc.cluster.local:8443/realms/homelab

bao policy write kv-reader - <<'HCL'
path "secret/data/demo/*"     { capabilities = ["read"] }
path "secret/metadata/demo/*" { capabilities = ["read", "list"] }
path "secret/metadata/demo"   { capabilities = ["list"] }
HCL
# "admin" is the policy from Field Note 1, part VI (docs/harden-k8s-openbao.sh)

bao auth enable oidc
bao write auth/oidc/config \
  oidc_discovery_url="$KC" \
  oidc_discovery_ca_pem=@/tmp/root.pem \
  oidc_client_id=openbao \
  oidc_client_secret=openbao-client-secret-123 \
  default_role=default

# browser logins: UI and 'bao login -method=oidc'
bao write auth/oidc/role/default \
  role_type=oidc user_claim=preferred_username groups_claim=groups \
  bound_audiences=openbao oidc_scopes=openid \
  allowed_redirect_uris="https://bao.example.internal/ui/vault/auth/oidc/oidc/callback,http://localhost:8250/oidc/callback" \
  token_policies=default token_ttl=1h token_max_ttl=8h

# non-interactive test with an ID token (password grant) - remove afterwards
bao write auth/oidc/role/jwt-test \
  role_type=jwt user_claim=preferred_username groups_claim=groups \
  bound_audiences=openbao token_policies=default token_ttl=15m

# Keycloak group -> OpenBao external group -> policy
ACC=$(bao read -field=accessor sys/auth/oidc)
for pair in openbao-admins:admin openbao-readers:kv-reader; do
  name=${pair%%:*}; policy=${pair##*:}
  id=$(bao write -field=id identity/group name="$name" type=external policies="$policy")
  bao write identity/group-alias name="$name" mount_accessor="$ACC" canonical_id="$id"
done
