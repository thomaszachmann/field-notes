# Reaching Keycloak from a workstation

Keycloak's hostname is its cluster Service name. From outside the cluster:

    # /etc/hosts
    127.0.0.1  keycloak-service.keycloak.svc.cluster.local

    kubectl port-forward -n keycloak svc/keycloak-service 8443:8443

Trust the OpenBao root CA in the browser/OS (bao read -field=certificate pki/cert/ca).
Admin console: https://keycloak-service.keycloak.svc.cluster.local:8443/admin/
Initial admin: secret keycloak-initial-admin (user temp-admin - temporary, create a permanent admin first).
