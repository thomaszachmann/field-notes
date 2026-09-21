# NetHSM lab – Part VIII of Field Note 6

A software NetHSM (`nitrokey/nethsm:testing`, amd64 only – it dies under
emulation with `same data from timer`) plus an OpenBao with `seal "pkcs11"`
against it, in one namespace of an amd64 cluster.

| File | Purpose |
|---|---|
| `Dockerfile` | `openbao/openbao-hsm:2.6.2` + `nethsm-pkcs11` v3.0.0 (musl, per arch) + `opensc` for `pkcs11-tool`; pushed as `softxpert/openbao-nethsm:2.6.2`. Download the two `.so` files from the nethsm-pkcs11 release first – no checksums are published. |
| `nethsm.yaml` | namespace, NetHSM Deployment (TCP readiness probe – `/health/alive` answers 412 once Operational), Service, PVC for `/data` (state is a factory reset otherwise), provisioning Job (operator user, RSA key `openbao-unseal`) |
| `openbao-pre.yaml` | `p11nethsm.conf` as ConfigMap, operator passphrase as Secret – lab values, printed on purpose |
| `values-nethsm.yaml` | chart values: image, config mount, `BAO_HSM_PIN`, `seal "pkcs11"` with **`key_id`** (nethsm-pkcs11 exposes keys with an empty label) |
| `debug-pod.yaml` | same image/UID/mounts, `sleep` – for steps 1–6 |
| `np-deny.yaml`, `np-dns.yaml`, `np-ok.yaml` | the three NetworkPolicy states of step 11 |
| `debug-profile.json` | `kubectl debug --custom` profile: root + `SYS_PTRACE` for step 12 |

```sh
kubectl apply -f nethsm.yaml && kubectl -n nethsm-lab wait --for=condition=complete job/nethsm-provision
kubectl apply -f openbao-pre.yaml
helm upgrade --install openbao-lab openbao/openbao --version 0.29.4 -n nethsm-lab -f values-nethsm.yaml
kubectl -n nethsm-lab exec openbao-lab-0 -- bao operator init -recovery-shares=5 -recovery-threshold=3
kubectl -n nethsm-lab delete pod openbao-lab-0      # comes back unsealed
kubectl delete ns nethsm-lab                        # tear-down
```
