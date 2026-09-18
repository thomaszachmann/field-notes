# OpenBao Field Notes · Nº 1 of 9 – OpenBao on Kubernetes

Helm, Raft, init and unseal, Kubernetes auth – and what is still missing afterwards.

Files the note prints, for copying from here instead of from the PDF:

| Path | What |
|---|---|
| `rke2/config-server-1.yaml`, `config-server-n.yaml`, `config-agent.yaml` | RKE2 `/etc/rancher/rke2/config.yaml` for the first server, the other servers, the workers |
| `k8s/values.yaml` | the Helm values, state before hardening |
| `k8s/values-hardened.yaml` | audit device block + audit PVC (part VI.2), passed in addition |
| `openbao/admin.hcl` | the `admin` policy (part VI.3) |
| `commands.sh` | Appendix A as a file (not a script – init and unseal are interactive) |

| | |
|---|---|
| German | [`openbao-on-kubernetes-de.pdf`](openbao-on-kubernetes-de.pdf) |
| English | [`openbao-on-kubernetes-en.pdf`](openbao-on-kubernetes-en.pdf) |
| Source | `de.md`, `en.md`, `cover-de.json`, `cover-en.json` |

Build: `tools/build.sh openbao/01-openbao-on-kubernetes de` (or `en`) from the repository root.
