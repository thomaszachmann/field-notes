output "kubernetes_auth_accessor" { value = vault_auth_backend.kubernetes.accessor }
output "oidc_auth_accessor" { value = vault_jwt_auth_backend.oidc.accessor }
output "policies" { value = keys(vault_policy.this) }
