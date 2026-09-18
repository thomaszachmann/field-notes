---
title: "OpenTofu für den Cluster-OpenBao"
subtitle: "Jeder CLI-Schritt aus Nº 1, 2, 4 und 5 als Code: Auth-Methoden, Rollen, Policies, Engines – mit verschlüsseltem State, Import des Bestands und dem, was bewusst nicht in Tofu gehört"
author: "Thomas Zachmann"
lang: de
---

*Entwurf – noch nicht geschrieben.*

## Geplante Gliederung

- Worum es geht – vier Notes voller bao write (Nº 1, 2, 4, 5)
- Teil I – Provider, State-Verschlüsselung, Login (aus Nº 3 übernommen)
- Teil II – Kubernetes-Auth, Policies, KV-Mount als Code
- Teil III – Database-Engine: Connection ohne Passwort im State
- Teil IV – PKI: Mounts und Rollen ja, Root-Erzeugung nein
- Teil V – tofu import: den Bestand einfangen, plan muss leer sein
- Teil VI – Was schiefging
- Teil VII – Betrieb: Drift, Rotation, was manuell bleibt

## Voraussetzungen

Admin-Login am Cluster-OpenBao (Nº 1, Teil VI durchgeführt)


# Über den Autor

Thomas Zachmann ist freiberuflicher Platform Engineer in Hamburg. Er baut
Enterprise-Plattformen für Kubernetes, Cloud und AI-Workloads – von Identity
und Secrets über CI/CD und GitOps bis Observability – so, dass das interne
Team sie danach ohne ihn betreiben kann. Diese Field Notes entstehen aus
dieser Arbeit. Für Projektanfragen: [thomaszachmann.de](https://thomaszachmann.de).
