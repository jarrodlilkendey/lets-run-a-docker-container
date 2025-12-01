FROM node:22-alpine

# Enable pnpm via corepack
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy only package files first for better caching
COPY package.json pnpm-lock.yaml ./

# Install deps (production only)
RUN pnpm install --frozen-lockfile --prod

# Copy app source
COPY . .

EXPOSE 8080

CMD ["pnpm", "start"]
