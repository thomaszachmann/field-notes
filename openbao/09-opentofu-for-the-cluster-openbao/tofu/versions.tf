terraform {
  # 1.11+: write-only attributes (password_wo) and ephemeral variables, so
  # the database root password never reaches the state. import {} blocks
  # need 1.5+.
  required_version = ">= 1.11.0"

  required_providers {
    # No openbao/openbao provider exists; OpenBao keeps the Vault HTTP API and
    # the HashiCorp provider works unchanged, pointed at OpenBao via
    # VAULT_ADDR. Pin the last known good version if a release starts
    # asserting Vault specifics (Field Note 3).
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }

  # State and plan encrypted client side (Field Note 3): the OIDC client
  # secret and the PKI/database configuration are in the state.
  encryption {
    key_provider "pbkdf2" "main" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "main" {
      keys = key_provider.pbkdf2.main
    }
    state { method = method.aes_gcm.main }
    plan { method = method.aes_gcm.main }
  }
}

provider "vault" {
  # Deliberately empty: address from VAULT_ADDR, token from ~/.vault-token
  # (bao login -method=oidc or -method=userpass). Never a token in HCL.
}
