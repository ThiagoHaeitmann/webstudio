# Etapa 1: Build
FROM node:18 AS builder

WORKDIR /app

# Instala pnpm globalmente
RUN npm install -g pnpm

# Copiar dependências
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Copiar restante do código
COPY . .

# Build da aplicação
RUN pnpm build

# Etapa 2: Imagem final
FROM node:18-alpine

WORKDIR /app

RUN npm install -g pnpm

COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
RUN pnpm install --prod --frozen-lockfile

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["pnpm", "start"]
