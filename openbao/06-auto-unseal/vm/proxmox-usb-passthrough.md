# Nitrokey HSM 2 → VM: USB passthrough in Proxmox

Do this once, on the Proxmox host, before anything on the VM.

```sh
# 1. find the stick on the host
lsusb | grep -i nitrokey
#   Bus 001 Device 005: ID 20a0:4230 Clay Logic Nitrokey HSM

# 2. attach it to the VM by vendor:product (survives re-plugging into
#    another port; a bus/port binding would not)
qm set <vmid> -usb0 host=20a0:4230

# 3. a cold boot of the VM is the reliable way; hot-plug works on recent
#    QEMU but is not worth the uncertainty for an HSM
qm shutdown <vmid> && qm start <vmid>
```

Inside the VM:

```sh
lsusb | grep -i nitrokey            # must show 20a0:4230
sudo apt-get install -y opensc pcscd
sudo systemctl enable --now pcscd
pkcs11-tool --module /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so --list-slots
```

Expected: one slot with token label `SmartCard-HSM (UserPIN)` (or your
label after init). If `--list-slots` shows no token: `pcscd` not running, or
the passthrough did not take (check `qm config <vmid>` for `usb0`).

Caveat that belongs in the note: the VM's Ansible role sets
`ProtectSystem=strict` and a tight `RestrictAddressFamilies` on
openbao.service. The PKCS#11 module talks to `pcscd` over a Unix socket
(`/run/pcscd/pcscd.comm`) – `AF_UNIX` is already allowed, but the socket path
must be readable by the `openbao` user (group `pcscd` or a
`ReadWritePaths=/run/pcscd` drop-in).
