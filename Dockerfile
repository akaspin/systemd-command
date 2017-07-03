FROM golang:1.8.3 as builder

ENV REPO github.com/akaspin/systemd-unit
ENV BIN systemd-unit

WORKDIR /go/src/${REPO}
COPY . ./

RUN export V=`git describe --always --tags --dirty` && \
    CGO_ENABLED=0 go build -installsuffix cgo -ldflags "-s -w -X ${REPO}/command.V=${V}" -o /${BIN} . && \
    CGO_ENABLED=0 go build -installsuffix cgo -ldflags "-s -w -X ${REPO}/command.V=${V}" -tags debug -o /${BIN}-debug .

FROM alpine:3.5
COPY --from=builder /systemd-unit /systemd-unit-debug /usr/bin/