# OpenBao Field Notes · Nº 6 of 9 – Auto-Unseal with Transit and a Nitrokey HSM

**Status: planned.** No PDF yet.

*Two ways to get rid of manual unsealing: transit seal against a second OpenBao, and seal "pkcs11" with a USB HSM – migration, way back, failure behaviour*

German title: *Auto-Unseal mit Transit und Nitrokey HSM*

## Planned outline

- What this is about – the price of Shamir (Nº 1, Nº 3)
- Part I – Seal mechanisms: Shamir, transit, PKCS#11
- Part II – Transit seal: the VM OpenBao unseals the cluster OpenBao
- Part III – Nitrokey HSM 2: OpenSC, PKCS#11 slot, generating the key
- Part IV – seal "pkcs11" on the VM
- Part V – Migrating Shamir → auto-unseal and back (seal migrate)
- Part VI – What happens when the unsealer is gone
- Part VII – Operation: recovery keys, rotation, monitoring

## Prerequisites

Nitrokey HSM 2 on the VM via USB, SSH to the VM, a token on the VM OpenBao

The outlines in `de.draft.md` / `en.draft.md` become `de.md` / `en.md` when
the note is written; `tools/build-all.sh` only builds directories that have
`de.md` or `en.md`.
