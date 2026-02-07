FROM node:20-alpine AS builder
WORKDIR /app

# Install compiler (Wajib untuk Astro/Sharp)
RUN apk add --no-cache python3 make g++

# Aktifkan PNPM
RUN corepack enable

COPY package.json pnpm-lock.yaml ./

# Perhatikan: Pakai 'pnpm install', BUKAN 'npm ci'
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build

# ... (lanjut ke stage nginx)
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]