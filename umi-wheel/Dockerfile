FROM golang:1.19.9-alpine3.16 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

COPY ./umi-wheel /app/umi-wheel
COPY ./umi-node /app/umi-node
COPY ./umi-chain-umi /app/umi-chain-umi
COPY ./umi-service /app/umi-service
COPY ./umi-bindings /app/umi-bindings
COPY ./go.mod /app/go.mod
COPY ./go.sum /app/go.sum

WORKDIR /app/umi-wheel

RUN go build -o umi-wheel ./cmd/main.go

FROM alpine:3.16

COPY --from=builder /app/umi-wheel/umi-wheel /usr/local/bin

CMD ["umi-wheel"]
