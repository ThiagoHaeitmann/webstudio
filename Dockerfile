# Etapa 1: Build da aplicação
FROM node:18 AS builder

WORKDIR /app

# Copiar apenas arquivos de dependências primeiro
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copiar o restante do código e buildar
COPY . .
RUN yarn build

# Etapa 2: Imagem final para produção
FROM node:18-alpine

WORKDIR /app

# Copiar apenas o build e dependências necessárias
COPY --from=builder /app/package.json /app/yarn.lock ./
RUN yarn install --production --frozen-lockfile

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["yarn", "start"]
