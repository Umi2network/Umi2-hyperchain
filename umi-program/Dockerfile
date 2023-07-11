FROM --platform=$BUILDPLATFORM golang:1.19.9-alpine3.16 as builder

ARG VERSION=v0.0.0

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

# build umi-program with the shared go.mod & go.sum files
COPY ./umi-program /app/umi-program
COPY ./umi-node /app/umi-node
COPY ./umi-chain-umi /app/umi-chain-umi
COPY ./umi-service /app/umi-service
COPY ./umi-bindings /app/umi-bindings
COPY ./go.mod /app/go.mod
COPY ./go.sum /app/go.sum
COPY ./.git /app/.git

WORKDIR /app/umi-program

RUN go mod download

ARG TARGETOS TARGETARCH

RUN make umi-program VERSION="$VERSION" GOOS=$TARGETOS GOARCH=$TARGETARCH

FROM alpine:3.16

COPY --from=builder /app/umi-program/bin/umi-program /usr/local/bin

CMD ["umi-program"]
