# OpenBao Field Notes · Nº 9 of 9 – OpenTofu for the Cluster OpenBao

**Status: configuration written and validated, waiting for a login.** No
PDF yet – the cover preview is in `opentofu-for-the-cluster-openbao-*-preview.pdf`.

Every `bao write` from Field Notes 1, 2, 4, 5, 7 and 8 as code, in `tofu/`:

| File | Covers |
|---|---|
| `auth-kubernetes.tf` | Kubernetes auth, its config, roles `eso-demo`, `cert-manager`, `snapshot` |
| `policies.tf` + `policies/*.hcl` | the five policies, exported from the live instance |
| `kv.tf` | the KV v2 mount (values stay out of Tofu) |
| `database.tf` | connection `postgres-demo` with `password_wo`, roles `demo-app` and `miniflux` |
| `pki.tf` | both PKI mounts, URLs, role `cluster-internal` – **not** the CA certificates (see the comment) |
| `oidc.tf` | OIDC auth against Keycloak, role `default`, external groups and aliases |
| `imports.tf` | `import` blocks for all 26 existing objects – the first plan must import and change nothing |
| `versions.tf`, `variables.tf` | provider pin, encrypted state, ephemeral/write-only inputs |

`tofu fmt -check` and `tofu validate` pass against provider hashicorp/vault
5.11.0. What has **not** run is `tofu plan` – it needs a token with read
rights on everything, and the cluster OpenBao has no admin login until the
hardening from Nº 1 part VI (or the OIDC admin group from Nº 8) is in use.

## To finish the note

```sh
cd tofu
cp env.sh.example env.sh          # then: source env.sh
bao login -method=oidc role=default      # alice, group openbao-admins  (Nº 8)
#   or: bao login -method=userpass username=admin                       (Nº 1, part VI)
tofu init
tofu plan                          # expected: 26 to import, 0 to add/change/destroy
tofu apply
tofu plan                          # expected: No changes.
```

If the first plan shows a change, the HCL and the cluster disagree – the
note documents each such diff and fixes the HCL, not the cluster.

Already known: `vault_jwt_auth_backend` keeps the Keycloak client secret in
the state (no write-only variant) – hence the encrypted state. And the
identity group / alias IDs in `imports.tf` are UUIDs of this instance; on a
rebuild they change.

Planned outline: `de.draft.md` / `en.draft.md`.
