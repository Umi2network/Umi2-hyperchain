FROM --platform=$BUILDPLATFORM golang:1.19.9-alpine3.16 as builder

ARG VERSION=v0.0.0

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

# build umi-proposer with the shared go.mod & go.sum files
COPY ./umi-proposer /app/umi-proposer
COPY ./umi-bindings /app/umi-bindings
COPY ./umi-node /app/umi-node
COPY ./umi-service /app/umi-service
COPY ./umi-signer /app/umi-signer
COPY ./go.mod /app/go.mod
COPY ./go.sum /app/go.sum
COPY ./.git /app/.git

WORKDIR /app/umi-proposer

RUN go mod download

ARG TARGETOS TARGETARCH

RUN make umi-proposer VERSION="$VERSION" GOOS=$TARGETOS GOARCH=$TARGETARCH

FROM alpine:3.16

COPY --from=builder /app/umi-proposer/bin/umi-proposer /usr/local/bin

CMD ["umi-proposer"]
