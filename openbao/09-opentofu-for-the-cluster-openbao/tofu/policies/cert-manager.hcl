# cert-manager only signs CSRs through one role; it never sees a CA key.
path "pki_int/sign/cluster-internal" { capabilities = ["create", "update"] }
