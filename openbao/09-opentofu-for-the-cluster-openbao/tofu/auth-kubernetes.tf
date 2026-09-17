# Kubernetes auth: workloads log in with their ServiceAccount token, OpenBao
# verifies it via TokenReview (Field Note 1, part III).
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://kubernetes.default.svc:443"
  # In-cluster: OpenBao uses its own pod token and the built-in CA.
}

# One role per consumer: who (SA + namespace) and with which policy.
locals {
  k8s_roles = {
    eso-demo     = { sa = "demo", ns = "demo", policies = ["eso-demo"], ttl = 3600 }                            # Field Notes 2, 4
    cert-manager = { sa = "cert-manager-openbao", ns = "cert-manager", policies = ["cert-manager"], ttl = 600 } # Field Note 5
    snapshot     = { sa = "openbao-snapshot", ns = "openbao", policies = ["snapshot"], ttl = 900 }              # Field Note 7
  }
}

resource "vault_kubernetes_auth_backend_role" "this" {
  for_each                         = local.k8s_roles
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = each.key
  bound_service_account_names      = [each.value.sa]
  bound_service_account_namespaces = [each.value.ns]
  token_policies                   = each.value.policies
  token_ttl                        = each.value.ttl

  depends_on = [vault_policy.this]
}
