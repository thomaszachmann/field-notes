---
title: "Keycloak und OpenBao"
subtitle: "Keycloak im Cluster deployen, ein Realm mit Gruppen, OIDC-Login für OpenBao – und Gruppen, die zu Policies werden, statt Passwörtern, die in OpenBao liegen"
author: "Thomas Zachmann"
lang: de
---

*Entwurf – noch nicht geschrieben.*

## Geplante Gliederung

- Worum es geht – userpass ist ein Zwischenschritt (Nº 1, Nº 3)
- Teil I – Keycloak per Operator: Postgres (CNPG), Ingress, TLS aus Nº 5
- Teil II – Realm, Client, Gruppen, Mapper für die groups-Claim
- Teil III – OIDC-Auth in OpenBao: Discovery, Redirect-URIs, Rolle
- Teil IV – Gruppen → External Groups → Policies
- Teil V – Login per CLI und UI, Token-TTLs
- Teil VI – Was schiefging
- Teil VII – Betrieb: Break Glass ohne Keycloak, Ablösung von userpass

## Voraussetzungen

Ingress-Hostname für Keycloak und den OIDC-Redirect, Browser
