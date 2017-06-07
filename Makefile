REPO	= github.com/akaspin/systemd-command
BIN     = systemd-command

BENCH	= .
TESTS	= .

CWD 		= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VENDOR 		= $(CWD)/vendor
SRC 		= $(shell find . -type f \( -iname '*.go' ! -iname "*_test.go" \) -not -path "./vendor/*")
SRC_TEST 	= $(shell find . -type f -name '*_test.go' -not -path "./vendor/*")
SRC_VENDOR 	= $(shell find ./vendor -type f \( -iname '*.go' ! -iname "*_test.go" \))
PACKAGES    = $(shell cd $(GOPATH)/src/$(REPO) && go list ./... | grep -v /vendor/)

V=$(shell git describe --always --tags --dirty)
GOOPTS=-installsuffix cgo -ldflags '-s -w -X $(REPO)/command.V=$(V)'


###
### Dist
###

dist-docker: dist/$(BIN)-$(V)-linux-amd64.tar.gz
	docker build --build-arg V=$(V) -t akaspin/systemd-command:$(V) .

dist-docker-push: dist-docker
	echo $(V) | grep dirty && exit 2 || true
	docker push akaspin/systemd-command:$(V)
	docker tag akaspin/systemd-command:$(V) akaspin/systemd-command:latest
	docker push akaspin/systemd-command:latest

dist: \
	dist/$(BIN)-$(V)-linux-amd64.tar.gz


dist/$(BIN)-$(V)-%-amd64.tar.gz: dist/%/$(BIN) dist/%/$(BIN)-debug
	tar -czf $@ -C ${<D} $(notdir $^)

dist/%/$(BIN): $(SRC) $(SRC_VENDOR)
	@mkdir -p $(@D)
	GOPATH=$(GOPATH) CGO_ENABLED=0 GOOS=$* go build $(GOOPTS) -o $@ $(REPO)

dist/%/$(BIN)-debug: $(SRC) $(SRC_VENDOR)
	@mkdir -p $(@D)
	GOPATH=$(GOPATH) CGO_ENABLED=0 GOOS=$* go build $(GOOPTS) -tags debug -o $@ $(REPO)



###
### clean
###

clean: clean-dist

clean-dist:
	rm -rf dist


.PHONY: test