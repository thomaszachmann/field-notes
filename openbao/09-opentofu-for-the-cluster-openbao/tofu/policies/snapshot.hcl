# The snapshot job may do exactly one thing.
path "sys/storage/raft/snapshot" { capabilities = ["read"] }
