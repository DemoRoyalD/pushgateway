FROM golang:1.20.2-bullseye AS builder
WORKDIR /build
ENV GOPROXY https://goproxy.cn
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o pushgateway main.go

FROM debian:bullseye-slim AS runner
WORKDIR /app
COPY --from=builder /build/pushgateway /app/
ENTRYPOINT [ "/app/pushgateway" ]