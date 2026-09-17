# Readers: see what exists under secret/demo and read it, change nothing.
path "secret/data/demo/*"     { capabilities = ["read"] }
path "secret/metadata/demo/*" { capabilities = ["read", "list"] }
path "secret/metadata/demo"   { capabilities = ["list"] }
