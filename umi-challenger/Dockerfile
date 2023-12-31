FROM --platform=$BUILDPLATFORM golang:1.19.0-alpine3.15 as builder

ARG VERSION=v0.0.0

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

# build umi-challenger with the shared go.mod & go.sum files
COPY ./umi-challenger /app/umi-challenger
COPY ./umi-bindings /app/umi-bindings
COPY ./umi-node /app/umi-node
COPY ./umi-service /app/umi-service
COPY ./umi-signer /app/umi-signer
COPY ./go.mod /app/go.mod
COPY ./go.sum /app/go.sum
COPY ./.git /app/.git

WORKDIR /app/umi-challenger

RUN go mod download

ARG TARGETOS TARGETARCH

RUN make umi-challenger VERSION="$VERSION" GOOS=$TARGETOS GOARCH=$TARGETARCH

FROM alpine:3.15

COPY --from=builder /app/umi-challenger/bin/umi-challenger /usr/local/bin

CMD ["umi-challenger"]
