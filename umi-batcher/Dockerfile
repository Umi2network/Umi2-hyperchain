FROM --platform=$BUILDPLATFORM golang:1.19.9-alpine3.16 as builder

ARG VERSION=v0.0.0

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

# build umi-batcher with the shared go.mod & go.sum files
COPY ./umi-batcher /app/umi-batcher
COPY ./umi-bindings /app/umi-bindings
COPY ./umi-node /app/umi-node
COPY ./umi-service /app/umi-service
COPY ./umi-signer /app/umi-signer
COPY ./go.mod /app/go.mod
COPY ./go.sum /app/go.sum

COPY ./.git /app/.git

WORKDIR /app/umi-batcher

RUN go mod download

ARG TARGETOS TARGETARCH

RUN make umi-batcher VERSION="$VERSION" GOOS=$TARGETOS GOARCH=$TARGETARCH

FROM alpine:3.16

COPY --from=builder /app/umi-batcher/bin/umi-batcher /usr/local/bin

ENTRYPOINT ["umi-batcher"]
