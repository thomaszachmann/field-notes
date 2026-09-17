# Database secrets engine (Field Note 2): the connection to PostgreSQL and
# the two roles. The root password goes through password_wo and is never
# written to the state.
resource "vault_mount" "database" {
  path = "database"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres_demo" {
  backend       = vault_mount.database.path
  name          = "postgres-demo"
  allowed_roles = ["demo-app", "miniflux"]

  postgresql {
    connection_url          = "postgresql://{{username}}:{{password}}@postgres-postgresql.postgres.svc.cluster.local:5432/demodb?sslmode=disable"
    username                = "openbao"
    password_wo             = var.postgres_openbao_password
    password_wo_version     = var.postgres_openbao_password_version
    password_authentication = "scram-sha-256"
  }
}

# Least privilege on existing data: fine for an app that never creates tables.
resource "vault_database_secret_backend_role" "demo_app" {
  backend     = vault_mount.database.path
  name        = "demo-app"
  db_name     = vault_database_secret_backend_connection.postgres_demo.name
  default_ttl = 3600
  max_ttl     = 86400
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT CONNECT ON DATABASE demodb TO \"{{name}}\";",
    "GRANT USAGE ON SCHEMA public TO \"{{name}}\";",
    "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
    "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\";",
  ]
}

# Owner-role pattern: the dynamic user joins the fixed role 'miniflux' and
# every session runs as it, so the schema outlives the user (Field Note 2).
resource "vault_database_secret_backend_role" "miniflux" {
  backend     = vault_mount.database.path
  name        = "miniflux"
  db_name     = vault_database_secret_backend_connection.postgres_demo.name
  default_ttl = 3600
  max_ttl     = 86400
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}' IN ROLE miniflux; ALTER ROLE \"{{name}}\" SET ROLE miniflux;",
  ]
}
