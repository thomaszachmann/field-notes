# OpenBao Field Notes · Nº 6 of 9 – Auto-Unseal with a Nitrokey HSM 2

**Status: published** – [DE](auto-unseal-de.pdf) · [EN](auto-unseal-en.pdf), 33 pages each.

`seal "pkcs11"` for the cluster OpenBao from Nº 1: the Nitrokey HSM 2 hangs
off a Kubernetes worker (Proxmox USB passthrough), the pod gets the `pcscd`
socket as a hostPath, a custom image brings OpenBao's HSM build and OpenSC.
Migration from Shamir with `unseal -migrate`, and the proof: a pod that comes
up without a key. Part I explains seal, HSM, PKCS#11, SO/user PIN and DKEK
for readers who have never held an HSM.

## What changed against the plan

The prepared plan (first draft of this directory) assumed an AES-256 key and
the stick on the VM from Nº 3. Both turned out wrong:

- the SmartCard-HSM cannot do AES-GCM – only `CKM_RSA_PKCS_OAEP`, so the
  seal key is RSA-2048
- the stick ended up on the cluster worker, not the VM
- the token was initialised **without DKEK shares** – the key cannot be
  backed up; Part VII says what has to happen before production

`vm/pkcs11-setup.sh` and `ansible/README.md` still describe the AES/VM
variant. They stay as material for the follow-up (see below).

## Six errors, in order of appearance

| | Symptom | Cause |
|---|---|---|
| 1 | `this build of OpenBao has PKCS#11 disabled` | `openbao/openbao` is built without CGO – it takes `openbao/openbao-hsm` |
| 2 | `pin is required` with an existing Secret | zsh `read -p` ≠ bash `read -p`; the Secret was 0 bytes |
| 3 | `failed to find token`, "No smart card readers" in the debug pod | pcsc-lite 2.4 (protocol 4:5) vs. pcscd 2.0.3 (4:4) – pinned to 2.2.3 |
| 4 | `failed to find token with label: SmartCard-HSM (UserPIN)` | OpenSC 0.26 calls the token `SmartCard-HSM` |
| 5 | `no migration seal found` | `unseal -migrate` before the deploy |
| 6 | StatefulSet update forbidden | new `volumeClaimTemplate`; `--dry-run=server` does not catch it |

## Files

| File | Purpose |
|---|---|
| `de.md`, `en.md`, `cover-*.json` | the note and its cover |
| `vm/proxmox-usb-passthrough.md` | attach the stick to a VM (`qm set … -usb0 host=20a0:4230`) – used for the worker VM |
| `vm/pkcs11-setup.sh`, `ansible/README.md` | the original VM/AES variant – material for Nº 6b, not what the note does |
| `cluster/transit-setup.sh`, `cluster/values-transit.yaml` | transit seal against the VM OpenBao – the recommended next step (Part VIII, way A) |

## Follow-up

- **Nº 6b – one HSM for all pods**: stick moves to the VM, VM OpenBao gets
  `seal "pkcs11"`, cluster OpenBao gets `seal "transit"`. Part VIII weighs
  four ways and recommends this one.
- **OpenBao 2.7**: the HSM distribution is discontinued; PKCS#11 becomes a
  KMS plugin (glibc binary → UBI base image). Part IX has the draft.
- Re-initialise the token with DKEK shares before the seal counts as
  production (Part VII).

## How this note was written

Unlike the other notes, this one came out of a pair-programming session with
Claude Code. Every command was run on the cluster, every output is real; the
note says so in its introduction.
