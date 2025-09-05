# Etapa de build
FROM node:20 AS builder
WORKDIR /app

RUN npm install -g pnpm
RUN npm install -g npm@latest pnpm

# Copia o monorepo inteiro (inclusive tsconfig compartilhado)
RUN pnpm install --frozen-lockfile
RUN pnpm build

# Copiar dependências
COPY package.json pnpm-lock.yaml ./
COPY patches ./patches
RUN pnpm install --frozen-lockfile

# Copiar restante do código
COPY . .

RUN pnpm build

# Etapa final
FROM node:20-alpine
WORKDIR /app

RUN npm install -g pnpm

COPY --from=builder /app ./

EXPOSE 3000
CMD ["pnpm", "start"]
