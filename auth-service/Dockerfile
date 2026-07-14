FROM golang:1.21-alpine AS builder
RUN apk add --no-cache build-base git ca-certificates
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags "-s -w" -o /app/auth-service ./...

FROM alpine:3.18
RUN apk add --no-cache ca-certificates wget
COPY --from=builder /app/auth-service /usr/local/bin/auth-service
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chmod +x /usr/local/bin/auth-service
USER appuser
EXPOSE 8001
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- --timeout=5 --tries=1 http://127.0.0.1:8001/health || exit 1
ENTRYPOINT ["/usr/local/bin/auth-service"]
