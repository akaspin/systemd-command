FROM alpine:3.5

RUN apk --no-cache add ca-certificates
RUN apk --no-cache add --virtual .buildpack curl unzip && \
    curl -sSL https://releases.hashicorp.com/consul/0.8.3/consul_0.8.3_linux_amd64.zip > /tmp/consul_0.8.3_linux_amd64.zip && \
    unzip -d /usr/bin/ -Xo /tmp/consul_0.8.3_linux_amd64.zip && \
    rm -rf /tmp/consul_0.8.3_linux_amd64.zip && \
    curl -sSL https://releases.hashicorp.com/consul-template/0.18.3/consul-template_0.18.3_linux_amd64.tgz | tar -xzv -C /usr/bin/ && \
    mkdir -p /etc/consul && \
    curl -sSL https://github.com/asteris-llc/smlr/releases/download/0.0.1/smlr_0.0.1_linux_amd64.tar.gz | tar -xzv -C / && \
    mv smlr_0.0.1_linux_amd64 /usr/bin/slmr && \
    apk del .buildpack

ARG V=bad

ADD dist/systemd-command-$V-linux-amd64.tar.gz /usr/bin/
