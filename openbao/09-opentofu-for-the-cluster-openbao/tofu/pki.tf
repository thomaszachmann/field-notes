# PKI (Field Note 5): mounts, URLs and the role are code. The CA
# certificates themselves are NOT - generating the root is a one-time act
# that a 'tofu destroy' must never undo, and the provider cannot import an
# existing root. They stay in the runbook (openbao/pki-setup.sh of Nº 5).
resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
  max_lease_ttl_seconds     = 315360000 # 10 years
  default_lease_ttl_seconds = 315360000
  lifecycle { prevent_destroy = true }
}

resource "vault_mount" "pki_int" {
  path                      = "pki_int"
  type                      = "pki"
  max_lease_ttl_seconds     = 157680000 # 5 years
  default_lease_ttl_seconds = 157680000
  lifecycle { prevent_destroy = true }
}

resource "vault_pki_secret_backend_config_urls" "pki" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["${var.openbao_addr_in_cluster}/v1/pki/ca"]
  crl_distribution_points = ["${var.openbao_addr_in_cluster}/v1/pki/crl"]
}

resource "vault_pki_secret_backend_config_urls" "pki_int" {
  backend                 = vault_mount.pki_int.path
  issuing_certificates    = ["${var.openbao_addr_in_cluster}/v1/pki_int/ca"]
  crl_distribution_points = ["${var.openbao_addr_in_cluster}/v1/pki_int/crl"]
}

# What cert-manager may ask for. Every field is a decision (Nº 5, part II);
# keycloak.svc was added in Nº 8 - short names are per namespace.
resource "vault_pki_secret_backend_role" "cluster_internal" {
  backend            = vault_mount.pki_int.path
  name               = "cluster-internal"
  allowed_domains    = ["svc.cluster.local", "demo.svc", "keycloak.svc", "example.internal"]
  allow_subdomains   = true
  allow_bare_domains = false
  allow_glob_domains = false
  allow_ip_sans      = false
  enforce_hostnames  = true
  key_type           = "ec"
  key_bits           = 256
  ttl                = "720h"
  max_ttl            = "2160h"
  server_flag        = true
  client_flag        = false
  require_cn         = false
}
