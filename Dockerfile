# Stage 1: Use Go image to build the binary (optional if binary is already built outside)
# FROM golang:1.22-alpine AS builder
# WORKDIR /app
# COPY . .
# RUN go build -o app

# Stage 2: Use minimal base image for runtime
FROM alpine:3.20

# Set working directory inside container
WORKDIR /app

# Copy the pre-built binary from Jenkins workspace
COPY app .

# Make sure binary is executable
RUN chmod +x app

# Default command when container runs
CMD ["./app"]
