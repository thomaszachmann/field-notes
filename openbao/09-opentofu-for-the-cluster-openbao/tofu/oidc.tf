# OIDC against Keycloak (Field Note 8). Groups arrive in the ID token as the
# "groups" claim; external groups here turn them into policies.
resource "vault_jwt_auth_backend" "oidc" {
  path                  = "oidc"
  type                  = "oidc"
  oidc_discovery_url    = var.keycloak_issuer
  oidc_discovery_ca_pem = var.pki_root_ca_pem
  oidc_client_id        = "openbao"
  oidc_client_secret    = var.keycloak_client_secret
  default_role          = "default"
}

resource "vault_jwt_auth_backend_role" "default" {
  backend         = vault_jwt_auth_backend.oidc.path
  role_name       = "default"
  role_type       = "oidc"
  user_claim      = "preferred_username"
  groups_claim    = "groups"
  bound_audiences = ["openbao"]
  oidc_scopes     = ["openid"]
  allowed_redirect_uris = [
    "https://bao.example.internal/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]
  token_policies = ["default"] # rights come from the groups, not the role
  token_ttl      = 3600
  token_max_ttl  = 28800
}

# Keycloak group -> external group -> policy. The alias name must equal the
# claim value exactly (mapper full.path=false).
locals {
  oidc_groups = {
    openbao-admins  = ["admin"]
    openbao-readers = ["kv-reader"]
  }
}

resource "vault_identity_group" "external" {
  for_each = local.oidc_groups
  name     = each.key
  type     = "external"
  policies = each.value

  depends_on = [vault_policy.this]
}

resource "vault_identity_group_alias" "oidc" {
  for_each       = local.oidc_groups
  name           = each.key
  mount_accessor = vault_jwt_auth_backend.oidc.accessor
  canonical_id   = vault_identity_group.external[each.key].id
}
