# OpenBao Field Notes · Nº 9 – OpenTofu for the Cluster OpenBao

**Status: planned.** No PDF yet.

*Every CLI step from Nº 1, 2, 4 and 5 as code: auth methods, roles, policies, engines – with encrypted state, importing what exists, and what deliberately stays out of Tofu*

German title: *OpenTofu für den Cluster-OpenBao*

## Planned outline

- What this is about – four notes full of bao write (Nº 1, 2, 4, 5)
- Part I – Provider, state encryption, login (taken from Nº 3)
- Part II – Kubernetes auth, policies, KV mount as code
- Part III – Database engine: connection without a password in the state
- Part IV – PKI: mounts and roles yes, root generation no
- Part V – tofu import: capturing what exists, plan must be empty
- Part VI – What went wrong
- Part VII – Operation: drift, rotation, what stays manual

## Prerequisites

admin login on the cluster OpenBao (Nº 1, Part VI carried out)

The outlines in `de.draft.md` / `en.draft.md` become `de.md` / `en.md` when
the note is written; `tools/build-all.sh` only builds directories that have
`de.md` or `en.md`.
