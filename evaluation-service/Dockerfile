FROM golang:1.21-alpine AS builder
RUN apk add --no-cache build-base git ca-certificates
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -installsuffix cgo -o /app/evaluation-service .

FROM alpine:3.18
RUN apk add --no-cache ca-certificates wget
COPY --from=builder /app/evaluation-service /usr/local/bin/evaluation-service
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
EXPOSE 8004
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8004/health || exit 1
ENTRYPOINT ["/usr/local/bin/evaluation-service"]
