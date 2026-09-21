FROM openbao/openbao-hsm:2.6.2
ARG TARGETARCH
USER root
# nethsm-pkcs11 v3.0.0, musl build (Alpine). No checksums are published for
# this release; the .so was verified by ELF header and architecture only.
COPY libnethsm_pkcs11-x86_64.so /tmp/x86_64.so
COPY libnethsm_pkcs11-aarch64.so /tmp/aarch64.so
RUN set -eu; case "$TARGETARCH" in amd64) a=x86_64;; arm64) a=aarch64;; *) echo "unsupported $TARGETARCH"; exit 1;; esac; \
    mkdir -p /usr/lib/nitrokey /etc/nitrokey && cp /tmp/$a.so /usr/lib/nitrokey/libnethsm_pkcs11.so && rm /tmp/*.so && \
    apk add --no-cache opensc pcsc-lite-libs   # pkcs11-tool for the debug steps
USER openbao
