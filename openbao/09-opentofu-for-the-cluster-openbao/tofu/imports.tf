# Everything below already exists - created by hand in Field Notes 1, 2, 4,
# 5, 7 and 8. These blocks let 'tofu plan' adopt it; the first plan must
# show only imports and NO changes. If it shows a change, the HCL and the
# cluster disagree - fix the HCL, not the cluster.
import {
  to = vault_auth_backend.kubernetes
  id = "kubernetes"
}
import {
  to = vault_kubernetes_auth_backend_config.this
  id = "auth/kubernetes/config"
}
import {
  to = vault_kubernetes_auth_backend_role.this["eso-demo"]
  id = "auth/kubernetes/role/eso-demo"
}
import {
  to = vault_kubernetes_auth_backend_role.this["cert-manager"]
  id = "auth/kubernetes/role/cert-manager"
}
import {
  to = vault_kubernetes_auth_backend_role.this["snapshot"]
  id = "auth/kubernetes/role/snapshot"
}

import {
  to = vault_policy.this["admin"]
  id = "admin"
}
import {
  to = vault_policy.this["eso-demo"]
  id = "eso-demo"
}
import {
  to = vault_policy.this["cert-manager"]
  id = "cert-manager"
}
import {
  to = vault_policy.this["snapshot"]
  id = "snapshot"
}
import {
  to = vault_policy.this["kv-reader"]
  id = "kv-reader"
}

import {
  to = vault_mount.secret
  id = "secret"
}
import {
  to = vault_mount.database
  id = "database"
}
import {
  to = vault_database_secret_backend_connection.postgres_demo
  id = "database/config/postgres-demo"
}
import {
  to = vault_database_secret_backend_role.demo_app
  id = "database/roles/demo-app"
}
import {
  to = vault_database_secret_backend_role.miniflux
  id = "database/roles/miniflux"
}

import {
  to = vault_mount.pki
  id = "pki"
}
import {
  to = vault_mount.pki_int
  id = "pki_int"
}
import {
  to = vault_pki_secret_backend_config_urls.pki
  id = "pki/config/urls"
}
import {
  to = vault_pki_secret_backend_config_urls.pki_int
  id = "pki_int/config/urls"
}
import {
  to = vault_pki_secret_backend_role.cluster_internal
  id = "pki_int/roles/cluster-internal"
}

import {
  to = vault_jwt_auth_backend.oidc
  id = "oidc"
}
import {
  to = vault_jwt_auth_backend_role.default
  id = "auth/oidc/role/default"
}
import {
  to = vault_identity_group.external["openbao-admins"]
  id = "6ed2f20e-4381-b73b-1ffb-bc2d860374b9"
}
import {
  to = vault_identity_group.external["openbao-readers"]
  id = "56742cd4-3e5b-a16c-57ca-bc3528e2a0b2"
}
import {
  to = vault_identity_group_alias.oidc["openbao-admins"]
  id = "83495045-0bb5-c485-bc68-fdcb4d006813"
}
import {
  to = vault_identity_group_alias.oidc["openbao-readers"]
  id = "5385301f-eb1a-7aec-1643-b1d1efe6ddb2"
}
