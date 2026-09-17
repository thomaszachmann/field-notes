variable "state_passphrase" {
  description = "Passphrase for state/plan encryption (min. 16 chars). From TF_VAR_state_passphrase."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.state_passphrase) >= 16
    error_message = "PBKDF2 requires at least 16 characters."
  }
}

variable "openbao_addr_in_cluster" {
  description = "Address workloads use to reach OpenBao (AIA/CRL URLs in certificates)."
  type        = string
  default     = "http://openbao.openbao.svc:8200"
}

variable "postgres_openbao_password" {
  description = "Password of the PostgreSQL role 'openbao' (Field Note 2). Write-only: sent on create/rotate, never stored. From TF_VAR_postgres_openbao_password."
  type        = string
  ephemeral   = true
}

variable "postgres_openbao_password_version" {
  description = "Bump to re-send the database password (write-only attributes have no drift detection)."
  type        = number
  default     = 1
}

variable "keycloak_issuer" {
  description = "OIDC issuer of the Keycloak realm (Field Note 8)."
  type        = string
  default     = "https://keycloak-service.keycloak.svc.cluster.local:8443/realms/homelab"
}

variable "keycloak_client_secret" {
  description = "Client secret of the Keycloak client 'openbao'. The provider stores it in the (encrypted) state - no write-only variant exists for vault_jwt_auth_backend."
  type        = string
  sensitive   = true
}

variable "pki_root_ca_pem" {
  description = "Root CA certificate (PEM) OpenBao must trust for the Keycloak discovery URL - the CA from Field Note 5. Read it with: bao read -field=certificate pki/cert/ca"
  type        = string
}
