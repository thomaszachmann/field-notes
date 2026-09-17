# OpenBao Field Notes · Nº 7 of 9 – Raft Snapshots from the Cluster

A CronJob that logs in with its ServiceAccount, takes and verifies the Raft
snapshot and uploads it to MinIO; a staleness check; a restore drill on an
isolated second instance with two key sets. Includes the manifests in `k8s/`
(MinIO values, CronJobs, drill values, NetworkPolicy).

| | |
|---|---|
| German | [`snapshots-from-the-cluster-de.pdf`](snapshots-from-the-cluster-de.pdf) |
| English | [`snapshots-from-the-cluster-en.pdf`](snapshots-from-the-cluster-en.pdf) |
| Source | `de.md`, `en.md`, `cover-de.json`, `cover-en.json` |

Build: `tools/build.sh openbao/07-snapshots-from-the-cluster de` (or `en`) from the repository root.
