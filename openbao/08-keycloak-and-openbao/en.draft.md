---
title: "Keycloak and OpenBao"
subtitle: "Deploying Keycloak in the cluster, a realm with groups, OIDC login for OpenBao – and groups that become policies instead of passwords that live in OpenBao"
author: "Thomas Zachmann"
lang: en
---

*Draft – not written yet.*

## Planned outline

- What this is about – userpass is an interim step (Nº 1, Nº 3)
- Part I – Keycloak via operator: Postgres (CNPG), ingress, TLS from Nº 5
- Part II – Realm, client, groups, mapper for the groups claim
- Part III – OIDC auth in OpenBao: discovery, redirect URIs, role
- Part IV – Groups → external groups → policies
- Part V – Login via CLI and UI, token TTLs
- Part VI – What went wrong
- Part VII – Operation: break glass without Keycloak, retiring userpass

## Prerequisites

ingress hostname for Keycloak and the OIDC redirect, a browser
