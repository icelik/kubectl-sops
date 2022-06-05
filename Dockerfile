ARG BUILDPLATFORM
FROM ${BUILDPLATFORM}alpine:3
ENV XDG_CONFIG_HOME=/config

ARG KUBE_VERSION
ARG SOPS_VERSION
ARG KSOPS_VERSION
ARG KUSTOMIZE_VERSION
ARG TARGETOS
ARG TARGETARCH

ADD install-ksops.sh .

RUN apk -U upgrade \
    && apk add --no-cache ca-certificates bash git openssh curl gettext tar gzip \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && mkdir /config \
    && chmod g+rwx /config /root \
    && wget -q https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.${TARGETOS}.${TARGETARCH} -O /usr/local/bin/sops \
    && wget -q https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_${TARGETOS}.${TARGETARCH}.tar.gz -O ./kustomize.tar.gz \
    && tar xzf kustomize.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/kustomize \
    && chmod +x /usr/local/bin/sops \
    && chmod +x ./install-ksops.sh \
    && echo "**** KUBECTL version ${KUBE_VERSION} ****" \
    && echo "**** SOPS version ${SOPS_VERSION} ****" \
    && echo "**** KSOPS version ${KSOPS_VERSION} ****" \
    && echo "**** KUSTOMIZE version ${KUSTOMIZE_VERSION} ****" \
    && ./install-ksops.sh \
    && rm -rf ./install-ksops.sh

WORKDIR /config

CMD bash
