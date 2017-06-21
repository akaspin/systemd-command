FROM alpine:3.5

RUN apk --no-cache add --virtual .buildpack curl && \
    curl -sSL https://github.com/asteris-llc/smlr/releases/download/0.0.1/smlr_0.0.1_linux_amd64.tar.gz | tar -xzv -C / && \
    mv smlr_0.0.1_linux_amd64 /usr/bin/slmr && \
    apk del .buildpack

ARG V=bad

ADD dist/systemd-unit-$V-linux-amd64.tar.gz /usr/bin/
