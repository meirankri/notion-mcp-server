FROM node:20-slim AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --ignore-scripts

COPY . .
RUN npm run build
RUN node scripts/build-cli.js

FROM node:20-slim

WORKDIR /app

COPY --from=builder /app /app

RUN npm link

ENV PORT=8080
ENV MCP_PORT=8080

EXPOSE 8080

# 👇 LA LIGNE CRUCIALE
CMD ["notion-mcp-server", "sse"]
