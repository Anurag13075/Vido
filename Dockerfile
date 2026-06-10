FROM node:20-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    python3-pip \
    curl \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://bun.sh/install | bash

ENV BUN_INSTALL=/root/.bun
ENV PATH=/root/.bun/bin:/usr/local/bin:$PATH
WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml tsconfig.json vite.config.ts ./
COPY . .

RUN bun install --frozen-lockfile
RUN bun run build

ENV API_PORT=3001
ENV PORT=5000

EXPOSE 5000

CMD ["bash", "-lc", "bun run server/index.ts"]
