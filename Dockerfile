FROM cgr.dev/chainguard/go@sha256:e69d8becae614abc5037093bead1f40bd031dd3483657f0cbeaa7e2c9e044a66 AS builder

ARG VERSION=dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -X skillguard/cmd.Version=${VERSION}" -o skillguard .

FROM cgr.dev/chainguard/static@sha256:a4e031f6d32f1af65a85b6925a9489db7787f09c73eefcd81793215c904d515d

COPY --from=builder /app/skillguard /skillguard

USER nonroot

ENTRYPOINT ["/skillguard"]
