# Étape 1 : build du code TypeScript
FROM node:20-slim AS builder

WORKDIR /app

# Copie des fichiers de dépendances
COPY package*.json ./

# Installation des dépendances sans les dev
RUN npm ci --ignore-scripts

# Copie du code
COPY . .

# Build du CLI MCP
RUN npm run build
RUN node scripts/build-cli.js

# Étape 2 : image finale
FROM node:20-slim

WORKDIR /app

# Copier les fichiers construits
COPY --from=builder /app /app

# Lier le binaire `notion-mcp-server` globalement
RUN npm link

# Cloud Run écoute sur $PORT
ENV PORT=8080
EXPOSE 8080

CMD ["notion-mcp-server"]
