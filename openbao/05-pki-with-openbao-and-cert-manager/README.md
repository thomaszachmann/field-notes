# OpenBao Field Notes · Nº 5 of 9 – PKI with OpenBao and cert-manager

Root and intermediate CA in OpenBao, a role that dictates what gets signed,
cert-manager as the client that only sends CSRs. Ingress via annotation,
service-to-service via Certificate, renewal and revocation. Includes the
manifests in `k8s/` and the OpenBao setup in `openbao/pki-setup.sh`.

| | |
|---|---|
| German | [`pki-with-openbao-and-cert-manager-de.pdf`](pki-with-openbao-and-cert-manager-de.pdf) |
| English | [`pki-with-openbao-and-cert-manager-en.pdf`](pki-with-openbao-and-cert-manager-en.pdf) |
| Source | `de.md`, `en.md`, `cover-de.json`, `cover-en.json` |

Build: `tools/build.sh openbao/05-pki-with-openbao-and-cert-manager de` (or `en`) from the repository root.
