# Ansible changes for seal "pkcs11" (to merge into roles/openbao of the VM repo)

`defaults/main.yml` – new variables, off by default:

```yaml
openbao_seal_pkcs11_enabled: false
openbao_seal_pkcs11_lib: /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
openbao_seal_pkcs11_slot: ""          # from pkcs11-tool --list-slots
openbao_seal_pkcs11_key_label: openbao-seal
openbao_seal_pkcs11_mechanism: "0x1087"   # CKM_AES_GCM
# the PIN is NOT a variable: it lands in /etc/openbao/hsm.env (0600) by hand,
# like the snapshot token - a secret value that has to be a file on the VM
```

`tasks/install.yml` – packages when enabled: `opensc`, `pcscd`; `pcscd`
enabled and started; user `openbao` added to group `pcscd`.

`tasks/preflight.yml` – when enabled: assert the module file exists and
`pkcs11-tool --list-slots` shows a token; abort with instructions otherwise.

`templates/openbao.hcl.j2` – after the listener block:

```jinja
{% if openbao_seal_pkcs11_enabled %}
seal "pkcs11" {
  lib            = "{{ openbao_seal_pkcs11_lib }}"
  slot           = "{{ openbao_seal_pkcs11_slot }}"
  key_label      = "{{ openbao_seal_pkcs11_key_label }}"
  mechanism      = "{{ openbao_seal_pkcs11_mechanism }}"
}
{% endif %}
```

`templates/10-hardening.conf.j2` – when enabled:

```ini
EnvironmentFile=-/etc/openbao/hsm.env      # BAO_HSM_PIN=...
ReadWritePaths=/run/pcscd
```

`helpers.yml` – `openbao-unseal` learns the migrated state: with a pkcs11
seal there is nothing to unseal after a restart; the script should say so and
exit 0 instead of prompting for keys.
