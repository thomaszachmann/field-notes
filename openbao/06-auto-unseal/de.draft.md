---
title: "Auto-Unseal mit Transit und Nitrokey HSM"
subtitle: "Zwei Wege, das manuelle Entsiegeln loszuwerden: Transit-Seal gegen einen zweiten OpenBao, und seal "pkcs11" mit einem USB-HSM – Migration, Rückweg, Ausfallverhalten"
author: "Thomas Zachmann"
lang: de
---

*Entwurf – noch nicht geschrieben.*

## Geplante Gliederung

- Worum es geht – der Preis von Shamir (Nº 1, Nº 3)
- Teil I – Seal-Mechanismen: Shamir, Transit, PKCS#11
- Teil II – Transit-Seal: der VM-OpenBao entsiegelt den Cluster-OpenBao
- Teil III – Nitrokey HSM 2: OpenSC, PKCS#11-Slot, Key erzeugen
- Teil IV – seal "pkcs11" auf der VM
- Teil V – Migration Shamir → Auto-Unseal und zurück (seal migrate)
- Teil VI – Was passiert, wenn der Unsealer weg ist
- Teil VII – Betrieb: Recovery-Keys, Rotation, Monitoring

## Voraussetzungen

Nitrokey HSM 2 per USB an der VM, SSH auf die VM, ein Token am VM-OpenBao


# Über den Autor

Thomas Zachmann ist freiberuflicher Platform Engineer in Hamburg. Er baut
Enterprise-Plattformen für Kubernetes, Cloud und AI-Workloads – von Identity
und Secrets über CI/CD und GitOps bis Observability – so, dass das interne
Team sie danach ohne ihn betreiben kann. Diese Field Notes entstehen aus
dieser Arbeit. Für Projektanfragen: [thomaszachmann.de](https://thomaszachmann.de).
