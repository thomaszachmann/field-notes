# KV v2 at secret/ (Field Note 4). Only the mount - the values are written
# by hand (bao kv put) or pushed from the cluster (PushSecret). Never here.
resource "vault_mount" "secret" {
  path    = "secret"
  type    = "kv"
  options = { version = "2" }
}
