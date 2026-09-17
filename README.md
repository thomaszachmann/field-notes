# Field Notes

Short, free guides from a homelab, by **Thomas Zachmann**. Each one walks a
single piece of infrastructure from an empty system to a verified state – by
hand, with every command, every manifest and every error that happened along
the way. They are deliberately written without AI assistance as a shortcut:
the point is to understand which components are involved and how the flow
runs, well enough to draw the architecture on a blank sheet of paper.

Every note is available in German and English as a PDF. The Markdown sources,
cover data and manifests are in this repository; the PDFs are built from
them with `tools/build.sh`.

| Nº | Title | Read |
|---|---|---|
| 1 | **OpenBao on Kubernetes** – Helm, Raft, init and unseal, Kubernetes auth, and what is still missing afterwards | [DE](01-openbao-on-kubernetes/openbao-on-kubernetes-de.pdf) · [EN](01-openbao-on-kubernetes/openbao-on-kubernetes-en.pdf) |
| 2 | **Dynamic Database Credentials with OpenBao** – short-lived PostgreSQL access through the database secrets engine and the External Secrets Operator, Miniflux as the worked example | [DE](02-openbao-dynamic-credentials/openbao-dynamic-credentials-de.pdf) · [EN](02-openbao-dynamic-credentials/openbao-dynamic-credentials-en.pdf) |
| 3 | **OpenBao on a VM** – a single node with Ansible and OpenTofu: installation, bootstrap runbook, snapshots, disaster recovery | [DE](03-openbao-on-a-vm/openbao-on-a-vm-de.pdf) · [EN](03-openbao-on-a-vm/openbao-on-a-vm-en.pdf) |

The three OpenBao notes form a sequence: Nº 1 builds the secrets store in the
cluster, Nº 2 lets an application consume it, Nº 3 shows the same OpenBao on
a VM with the full bootstrap and recovery procedure that the cluster setup
still lacks.

## What the notes contain – and what they do not

Everything in them was actually carried out. Terminal output is real. Where a
setup falls short of what production would need, the note says so and names
the next step.

Hostnames, internal addresses and the administrator's username are replaced
by placeholders. Passwords that appear in plain text (`postgres123`,
`admin123`, …) belong to a throwaway development environment and are printed
on purpose so that the reader recognises them; every note says so in its
introduction.

## Going deeper

The notes assume the concepts – seal/unseal, auth methods, policies, secrets
engines, leases. Those are covered from the ground up, with labs that run on
a laptop, in **Vault in Practice**:
[leanpub.com/vault-in-practice](https://leanpub.com/vault-in-practice).

## Building the PDFs

```sh
tools/build.sh 02-openbao-dynamic-credentials de     # one note, one language
tools/build-all.sh                                   # everything
```

Needs `pandoc`, `pdfinfo` (poppler), `python3` and Google Chrome or Chromium.
`pypdf` is installed into `tools/.venv` on the first run. Web fonts (Inter
Tight, Inter, JetBrains Mono) are fetched from Google Fonts while the cover
renders.

Each note directory holds `de.md` / `en.md` (the text), `cover-de.json` /
`cover-en.json` (the cover copy), and where applicable a `k8s/` directory
with the manifests the note prints.

## License

Text and covers: [CC BY 4.0](LICENSE). Manifests, scripts and configuration
snippets: use them freely.
