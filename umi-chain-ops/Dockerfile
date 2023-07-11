FROM golang:1.19.9-alpine3.15 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

COPY ./umi-chain-umi /app/umi-chain-umi
COPY ./umi-bindings /app/umi-bindings
COPY ./umi-node /app/umi-node
COPY ./go.mod /app/go.mod
COPY ./go.sum /app/go.sum
COPY ./.git /app/.git

WORKDIR /app/umi-chain-umi

RUN make umi-migrate

FROM alpine:3.15

COPY --from=builder /app/umi-chain-umi2/bin/umi-migrate /usr/local/bin

ENTRYPOINT ["umi-migrate"]
