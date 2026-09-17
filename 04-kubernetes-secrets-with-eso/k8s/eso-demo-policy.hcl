# Policy of the Kubernetes auth role "eso-demo" - the identity the External
# Secrets Operator uses from namespace "demo". Grown over Field Notes 2 and 4;
# every line was added because a sync failed without it.

# ExternalSecret .data / dataFrom.extract: read the data path; the metadata
# path is what "bao kv get" and the UI use and what ESO reads for versions
path "secret/data/demo/demo-app"     { capabilities = ["read"] }
path "secret/metadata/demo/demo-app" { capabilities = ["read"] }
path "secret/data/demo/miniflux"     { capabilities = ["read"] }

# dataFrom.find: enumerate everything below the prefix. This reveals which
# secrets exist - grant it only where find is really needed
path "secret/metadata/demo"          { capabilities = ["list"] }

# PushSecret: reads data first (to compare), writes data, then writes
# custom_metadata (the managed-by marker) - three paths, not one
path "secret/data/demo/generated-token"     { capabilities = ["create", "read", "update"] }
path "secret/metadata/demo/generated-token" { capabilities = ["create", "read", "update"] }

# Dynamic credentials (Field Note 2)
path "database/creds/demo-app"       { capabilities = ["read"] }
path "database/creds/miniflux"       { capabilities = ["read"] }
