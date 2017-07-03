BIN     = systemd-unit
REPO	= github.com/akaspin/$(BIN)

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
### Release
###

release-check: $(SRC) $(SRC_TEST)
	echo $(V) | grep -Eo '^(\d+\.)+\d+$$'
	go vet $(PACKAGES)
	[[ -z `gofmt -d -s -e $^` ]]

release: release-check dist/$(BIN)-$(V)-linux-amd64.tar.gz
	-github-release -v release -r $(BIN) -t $(V) -u akaspin
	github-release -v upload -r $(BIN) -t $(V) -u akaspin -f dist/$(BIN)-$(V)-linux-amd64.tar.gz -n $(BIN)-$(V)-linux-amd64.tar.gz

###
### Dist
###

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
### Code
###

sources: $(SRC) $(SRC_TEST)
	go vet $(PACKAGES)
	go fmt $(PACKAGES)

###
### clean
###

clean: clean-dist

clean-dist:
	rm -rf dist

