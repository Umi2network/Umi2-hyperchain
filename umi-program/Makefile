GITCOMMIT := $(shell git rev-parse HEAD)
GITDATE := $(shell git show -s --format='%ct')
VERSION := v0.0.0

LDFLAGSSTRING +=-X main.GitCommit=$(GITCOMMIT)
LDFLAGSSTRING +=-X main.GitDate=$(GITDATE)
LDFLAGSSTRING +=-X github.com/ethereum-optimism/optimism/umi-program/version.Version=$(VERSION)
LDFLAGSSTRING +=-X github.com/ethereum-optimism/optimism/umi-program/version.Meta=$(VERSION_META)
LDFLAGS := -ldflags "$(LDFLAGSSTRING)"

umi-program: \
	umi-program-host \
	umi-program-client \
	umi-program-client-mips

umi-program-host:
	env GO111MODULE=on GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v $(LDFLAGS) -o ./bin/umi-program ./host/cmd/main.go

umi-program-client:
	env GO111MODULE=on GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v $(LDFLAGS) -o ./bin/umi-program-client ./client/cmd/main.go

umi-program-client-mips:
	env GO111MODULE=on GOOS=linux GOARCH=mips GOMIPS=softfloat go build -v $(LDFLAGS) -o ./bin/umi-program-client.elf ./client/cmd/main.go
	# verify output with: readelf -h bin/umi-program-client.elf
	# result is mips32, big endian, R3000

clean:
	rm -rf bin

test:
	go test -v ./...

lint:
	golangci-lint run -E goimports,sqlclosecheck,bodyclose,asciicheck,misspell,errorlint -e "errors.As" -e "errors.Is"

verify-goerli: umi-program-host umi-program-client
	env GO111MODULE=on go run ./verify/cmd/goerli.go $$L1URL $$L2URL

.PHONY: \
	umi-program \
	clean \
	test \
	lint
