# Every policy as a file: readable in a diff, reviewable one by one. Each
# line in these files was added because a sync, a job or a login failed
# without it (Field Notes 2, 4, 5, 7, 8).
locals {
  policies = ["admin", "eso-demo", "cert-manager", "snapshot", "kv-reader"]
}

resource "vault_policy" "this" {
  for_each = toset(local.policies)
  name     = each.key
  policy   = file("${path.module}/policies/${each.key}.hcl")
}
