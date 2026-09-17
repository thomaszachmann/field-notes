path "secret/data/demo/demo-app"     { capabilities = ["read"] }
path "secret/metadata/demo/demo-app" { capabilities = ["read"] }
path "secret/data/demo/miniflux"     { capabilities = ["read"] }
path "secret/metadata/demo"          { capabilities = ["list"] }
# PushSecret: reads data first (to compare), writes data, then writes
# custom_metadata (managed-by marker) - three paths, not one
path "secret/data/demo/generated-token"     { capabilities = ["create", "read", "update"] }
path "secret/metadata/demo/generated-token" { capabilities = ["create", "read", "update"] }
path "database/creds/demo-app"       { capabilities = ["read"] }
path "database/creds/miniflux"       { capabilities = ["read"] }
