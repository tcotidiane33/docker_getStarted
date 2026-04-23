# ✅ BON: Multi-stage Build (Échafaudages démontés!)

# STAGE 1: Builder (Le Chantier avec tous les outils)
FROM ubuntu:latest AS builder

# Installer Go dans le chantier
RUN apt-get update && \
    apt-get install -y golang-go && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copier les fichiers source
COPY go.mod main.go ./

# Compiler le binaire
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o server .

# STAGE 2: Production (La Maison Finie, sans les échafaudages)
FROM alpine:latest

# Installer certificats SSL (pour HTTPS)
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copier SEULEMENT le binaire compilé depuis le builder
COPY --from=builder /app/server .

EXPOSE 8080

# Lancer le binaire
CMD ["./server"]

# Résultat: Image de ~15MB au lieu de 800MB! 🎉
