# Step 1: Build stage
FROM golang:1.22 AS builder

WORKDIR /app

COPY . .

RUN go mod tidy
RUN go build -o app

# Step 2: Run stage (small image)
FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/app .

CMD ["./app"]
