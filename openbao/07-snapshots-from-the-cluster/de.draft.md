---
title: "Raft-Snapshots aus dem Cluster"
subtitle: "Ein CronJob, der sich mit seinem ServiceAccount anmeldet, den Snapshot prüft und nach S3 schreibt – und eine Restore-Probe auf einen Wegwerf-Cluster"
author: "Thomas Zachmann"
lang: de
---

*Entwurf – noch nicht geschrieben.*

## Geplante Gliederung

- Worum es geht – das PVC ist die einzige Kopie (Nº 1, Teil V)
- Teil I – Was ein Raft-Snapshot ist, und warum es kein inspect gibt
- Teil II – Policy und Kubernetes-Auth-Rolle für den Snapshot-Job
- Teil III – Der CronJob: save, verify, upload nach S3 (MinIO)
- Teil IV – Retention und Staleness-Check
- Teil V – Restore-Probe auf einen kind-Cluster: -force und zwei Key-Sätze
- Teil VI – Was schiefging
- Teil VII – Betrieb: Keys getrennt von Snapshots, Alarmierung

## Voraussetzungen

S3-kompatibles Ziel im Cluster (MinIO) oder extern
