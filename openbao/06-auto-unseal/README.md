# OpenBao Field Notes · Nº 6 of 9 – Auto-Unseal with Transit and a Nitrokey HSM

**Status: prepared, waiting for hardware.** No PDF yet – the cover preview
is in `auto-unseal-*-preview.pdf`.

Two ways to get rid of manual unsealing: the cluster OpenBao gets a transit
seal against the VM OpenBao; the VM OpenBao gets `seal "pkcs11"` with a
Nitrokey HSM 2. Both with `-migrate`, both with the way back.

## What is prepared

| File | Purpose |
|---|---|
| `vm/proxmox-usb-passthrough.md` | attach the stick to the VM (`qm set … -usb0 host=20a0:4230`), verify with `lsusb` and `pkcs11-tool` |
| `vm/pkcs11-setup.sh` | initialise the HSM, generate the AES-256 seal key, print the seal block and the migration steps |
| `ansible/README.md` | the variables, tasks and template changes for the VM role (to merge into the Ansible repo) |
| `cluster/transit-setup.sh` | transit engine, key, policy and periodic token on the VM; Secret and migration on the cluster |
| `cluster/values-transit.yaml` | the `seal "transit"` block and the env var for the chart values |

## What is still needed

- the Nitrokey HSM 2 on the VM (arrives 2026-09-18), its SO-PIN and User-PIN
- a login on the VM OpenBao (`bao login -method=userpass`) for the transit part
- three Shamir keys for each `unseal -migrate`, and the recovery keys afterwards

Planned outline: `de.draft.md` / `en.draft.md`.
