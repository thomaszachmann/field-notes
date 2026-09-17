# Field Notes

Short, free guides from a homelab, by **Thomas Zachmann**, organised in
series. The first series is about OpenBao; others (AI infrastructure, RAG,
LiteLLM) will follow in their own directories. Each note walks a single piece of infrastructure from an empty system to a verified
state – by hand, with every command, every manifest and every error that
happened along the way. They are deliberately written without AI assistance
as a shortcut: the point is to understand which components are involved and
how the flow runs, well enough to draw the architecture on a blank sheet of
paper.

Every note is available in German and English as a PDF. The Markdown sources,
cover data and manifests are in this repository; the PDFs are built from
them with `tools/build.sh`.

## OpenBao – nine notes, seven published

| Nº | Title | Read |
|---|---|---|
| 1 | **OpenBao on Kubernetes** – Helm, Raft, init and unseal, Kubernetes auth, and what is still missing afterwards | [DE](openbao/01-openbao-on-kubernetes/openbao-on-kubernetes-de.pdf) · [EN](openbao/01-openbao-on-kubernetes/openbao-on-kubernetes-en.pdf) |
| 2 | **Dynamic Database Credentials with OpenBao** – short-lived PostgreSQL access through the database secrets engine and the External Secrets Operator, Miniflux as the worked example | [DE](openbao/02-openbao-dynamic-credentials/openbao-dynamic-credentials-de.pdf) · [EN](openbao/02-openbao-dynamic-credentials/openbao-dynamic-credentials-en.pdf) |
| 3 | **OpenBao on a VM** – a single node with Ansible and OpenTofu: installation, bootstrap runbook, snapshots, disaster recovery | [DE](openbao/03-openbao-on-a-vm/openbao-on-a-vm-de.pdf) · [EN](openbao/03-openbao-on-a-vm/openbao-on-a-vm-en.pdf) |
| 4 | **Kubernetes Secrets with ESO and OpenBao** – static secrets from KV v2 into the cluster: `data`, `extract`, `find`, `template`, rotation with Reloader, `PushSecret` back | [DE](openbao/04-kubernetes-secrets-with-eso/kubernetes-secrets-with-eso-de.pdf) · [EN](openbao/04-kubernetes-secrets-with-eso/kubernetes-secrets-with-eso-en.pdf) |
| 5 | **PKI with OpenBao and cert-manager** – root and intermediate CA in OpenBao, certificates via cert-manager for ingress and service-to-service, renewal and revocation | [DE](openbao/05-pki-with-openbao-and-cert-manager/pki-with-openbao-and-cert-manager-de.pdf) · [EN](openbao/05-pki-with-openbao-and-cert-manager/pki-with-openbao-and-cert-manager-en.pdf) |
| 7 | **Raft Snapshots from the Cluster** – a CronJob with its own identity, verified archives to MinIO, a staleness check, and a restore drill on an isolated instance with two key sets | [DE](openbao/07-snapshots-from-the-cluster/snapshots-from-the-cluster-de.pdf) · [EN](openbao/07-snapshots-from-the-cluster/snapshots-from-the-cluster-en.pdf) |
| 8 | **Keycloak and OpenBao** – Keycloak in the cluster via operator, a realm as code, OIDC login for OpenBao, groups that become policies through external groups | [DE](openbao/08-keycloak-and-openbao/keycloak-and-openbao-de.pdf) · [EN](openbao/08-keycloak-and-openbao/keycloak-and-openbao-en.pdf) |

The notes form a sequence: Nº 1 builds the secrets store in the cluster, Nº 2
lets an application consume dynamic credentials, Nº 3 shows the same OpenBao
on a VM with the full bootstrap and recovery procedure that the cluster setup
still lacks, Nº 4 covers the everyday case of static secrets and what
rotation really means, Nº 5 moves the cluster's CA into OpenBao, Nº 7 backs
it all up and rehearses the restore, Nº 8 gives humans a login through Keycloak.

## Planned

| Nº | Working title | Depends on |
|---|---|---|
| 6 | [**Auto-Unseal with Transit and a Nitrokey HSM**](openbao/06-auto-unseal/) – transit seal against the VM OpenBao, and `seal "pkcs11"` with a Nitrokey HSM 2. Scripts, Proxmox passthrough guide and Ansible changes are prepared | the HSM (arriving), VM access |
| 9 | [**OpenTofu for the Cluster OpenBao**](openbao/09-opentofu-for-the-cluster-openbao/) – every CLI step from Nº 1, 2, 4, 5, 7 and 8 as code. The configuration is written, validated and carries import blocks for all 26 objects; only the first `tofu plan` is missing | an admin login (Nº 1 part VI or Nº 8) |

Each planned note has a directory with its README, the planned outline, the
cover copy and everything that could be prepared without the missing piece –
but no PDF until it has actually been run.

## What the notes contain – and what they do not

Everything in them was actually carried out. Terminal output is real. Where a
setup falls short of what production would need, the note says so and names
the next step.

Hostnames, internal addresses and the administrator's username are replaced
by placeholders. Passwords that appear in plain text (`postgres123`,
`admin123`, …) belong to a throwaway development environment and are printed
on purpose so that the reader recognises them; every note says so in its
introduction.

## Related

Tools like [nyrvex](https://nyrvex.com) generate the configuration of an AI
platform's secret store and identity provider – the two things these notes
build by hand. The notes are what you should understand before you let a
tool generate it.

## Going deeper

The notes assume the concepts – seal/unseal, auth methods, policies, secrets
engines, leases. Those are covered from the ground up, with labs that run on
a laptop, in **Vault in Practice**:
[leanpub.com/vault-in-practice](https://leanpub.com/vault-in-practice).

## Building the PDFs

```sh
tools/build.sh openbao/02-openbao-dynamic-credentials de   # one note, one language
tools/build-all.sh                                   # everything
```

Needs `pandoc`, `pdfinfo` (poppler), `python3` and Google Chrome or Chromium.
`pypdf` is installed into `tools/.venv` on the first run. The three fonts (Inter
Tight, Inter, JetBrains Mono – SIL Open Font License) are vendored in
`tools/fonts/`, so the build needs no network.

The layout is `<series>/<NN>-<slug>/`. Each note directory holds `de.md` /
`en.md` (the text), `cover-de.json` / `cover-en.json` (the cover copy), and
where applicable a `k8s/` or `openbao/` directory with the manifests and
scripts the note prints. A new series is a new top-level directory with its
own numbering; the cover's series line comes from `cover-*.json`.

## License and liability

Text and covers: [CC BY 4.0](LICENSE) – copy, share and adapt them, including
commercially, as long as the author is credited. Manifests, scripts and
configuration snippets: use them freely. Everything is provided as is,
without warranty; it was carried out in a development environment, and
reproducing it elsewhere is at your own risk.
