# OpenBao Field Notes · Nº 8 of 9 – Keycloak and OpenBao

Keycloak in the cluster via operator (CNPG database, TLS from the OpenBao
CA of Nº 5), a realm as code with client, group mapper, groups and users,
OIDC auth in OpenBao, Keycloak groups mapped to policies through external
groups. Proven with ID tokens; the browser route is documented. Includes the
manifests in `k8s/`, the OpenBao setup in `openbao/oidc-setup.sh` and a note
on reaching Keycloak from a workstation.

| | |
|---|---|
| German | [`keycloak-and-openbao-de.pdf`](keycloak-and-openbao-de.pdf) |
| English | [`keycloak-and-openbao-en.pdf`](keycloak-and-openbao-en.pdf) |
| Source | `de.md`, `en.md`, `cover-de.json`, `cover-en.json` |

Build: `tools/build.sh openbao/08-keycloak-and-openbao de` (or `en`) from the repository root.
