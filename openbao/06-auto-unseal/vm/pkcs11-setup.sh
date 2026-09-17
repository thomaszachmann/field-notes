#!/bin/sh
# Field Note 6, VM side: initialise the Nitrokey HSM 2 and create the AES
# key OpenBao will use for seal "pkcs11". Interactive - PINs are prompted,
# never passed as arguments. Run on the VM as a user in group pcscd/plugdev.
set -eu
MOD=/usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
LABEL=${LABEL:-openbao-seal}

echo "== slots"; pkcs11-tool --module $MOD --list-slots

echo "== initialise the token (ONLY on a fresh stick - this wipes it)"
echo "   SO-PIN (16 hex chars on a Nitrokey HSM 2) and User-PIN are prompted."
printf 'Initialise now? [yes/NO] '; read -r a; [ "$a" = yes ] && sc-hsm-tool --initialize --label "$LABEL" || echo "   skipped"

echo "== generate the seal key: AES-256, non-extractable, on the HSM"
pkcs11-tool --module $MOD --login --keygen --key-type AES:32 --label "$LABEL" \
  --id 01 --usage-decrypt --usage-encrypt --extractable=false 2>/dev/null \
  || pkcs11-tool --module $MOD --login --keygen --key-type AES:32 --label "$LABEL" --id 01

echo "== what the HSM holds now"; pkcs11-tool --module $MOD --login --list-objects

cat <<HCL

== seal block for /etc/openbao/openbao.hcl (Ansible: openbao_seal_pkcs11_* in defaults)
seal "pkcs11" {
  lib            = "$MOD"
  slot           = "<slot id from --list-slots>"
  pin            = "<User-PIN - better: BAO_HSM_PIN in the systemd unit's EnvironmentFile>"
  key_label      = "$LABEL"
  mechanism      = "0x1087"      # CKM_AES_GCM - one AES key, no separate HMAC key
}

== migration (OpenBao stays sealed until the migrate-unseal finishes)
sudo systemctl restart openbao           # picks up the seal block
bao operator unseal -migrate             # 3x with the Shamir keys - ONCE
bao status                               # Seal Type pkcs11, Recovery Seal true

== the way back (comment out the seal block, restart, then)
bao operator unseal -migrate             # with the RECOVERY keys this time
HCL
