---
title: "OpenTofu for the Cluster OpenBao"
subtitle: "Every CLI step from Nº 1, 2, 4 and 5 as code: auth methods, roles, policies, engines – with encrypted state, importing what exists, and what deliberately stays out of Tofu"
author: "Thomas Zachmann"
lang: en
---

*Draft – not written yet.*

## Planned outline

- What this is about – four notes full of bao write (Nº 1, 2, 4, 5)
- Part I – Provider, state encryption, login (taken from Nº 3)
- Part II – Kubernetes auth, policies, KV mount as code
- Part III – Database engine: connection without a password in the state
- Part IV – PKI: mounts and roles yes, root generation no
- Part V – tofu import: capturing what exists, plan must be empty
- Part VI – What went wrong
- Part VII – Operation: drift, rotation, what stays manual

## Prerequisites

admin login on the cluster OpenBao (Nº 1, Part VI carried out)


# About the author

Thomas Zachmann is a freelance platform engineer based in Hamburg. He builds
enterprise platforms for Kubernetes, cloud and AI workloads – from identity
and secrets through CI/CD and GitOps to observability – so that the in-house
team can run them without him afterwards. These Field Notes come out of that
work. For project enquiries: [thomaszachmann.de](https://thomaszachmann.de).
