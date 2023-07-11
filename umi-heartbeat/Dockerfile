FROM golang:1.18.0-alpine3.15 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

# build umi-heartbeat with local monorepo go modules
COPY ./umi-heartbeat /app/umi-heartbeat
COPY ./.git /app/.git
COPY ./umi-heartbeat/go.mod /app/go.mod
COPY ./umi-heartbeat/go.sum /app/go.sum

WORKDIR /app/umi-heartbeat

RUN make umi-heartbeat

FROM alpine:3.15

COPY --from=builder /app/umi-heartbeat/bin/umi-heartbeat /usr/local/bin

CMD ["umi-heartbeat"]
