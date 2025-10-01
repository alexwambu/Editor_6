# ---- Stage 1: Build geth ----
FROM golang:1.21 AS builder

RUN apt-get update && apt-get install -y make gcc g++ git

ARG GETH_VERSION=v1.13.14
RUN git clone --branch $GETH_VERSION --depth 1 https://github.com/ethereum/go-ethereum.git /go-ethereum

WORKDIR /go-ethereum
RUN go mod download
RUN make geth

# ---- Stage 2: Runtime ----
FROM debian:stable-slim

RUN apt-get update && apt-get install -y ca-certificates curl jq python3 python3-pip && rm -rf /var/lib/apt/lists/*
RUN pip3 install fastapi uvicorn transformers torch

COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/geth

WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
COPY health_server.py /app/health_server.py
COPY ml_editor.py /app/ml_editor.py
COPY password.txt /app/password.txt

RUN chmod +x /app/entrypoint.sh

EXPOSE 9636 30303 30303/udp 8000 8080

ENTRYPOINT ["/app/entrypoint.sh"]
