# OpenBao Field Notes · Nº 7 – Raft Snapshots from the Cluster

**Status: planned.** No PDF yet.

*A CronJob that logs in with its ServiceAccount, verifies the snapshot and writes it to S3 – and a restore drill on a throwaway cluster*

German title: *Raft-Snapshots aus dem Cluster*

## Planned outline

- What this is about – the PVC is the only copy (Nº 1, Part V)
- Part I – What a Raft snapshot is, and why there is no inspect
- Part II – Policy and Kubernetes auth role for the snapshot job
- Part III – The CronJob: save, verify, upload to S3 (MinIO)
- Part IV – Retention and staleness check
- Part V – Restore drill on a kind cluster: -force and two key sets
- Part VI – What went wrong
- Part VII – Operation: keys apart from snapshots, alerting

## Prerequisites

S3-compatible target in the cluster (MinIO) or external

The outlines in `de.draft.md` / `en.draft.md` become `de.md` / `en.md` when
the note is written; `tools/build-all.sh` only builds directories that have
`de.md` or `en.md`.
