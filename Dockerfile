ARG NODE_IMAGE=node:24-trixie-slim

FROM ${NODE_IMAGE} AS base
WORKDIR /repo
COPY package.json ./
RUN npm install -g "$(node -p 'require("./package.json").packageManager')" && pnpm --version

FROM base AS deps
COPY pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm fetch

FROM deps AS build-backend
COPY . .
RUN pnpm install --offline --frozen-lockfile --filter "@CATT_System/backend..."
ENV DATABASE_URL=postgresql://build:build@localhost:5432/build
RUN pnpm --filter @CATT_System/contracts build \
  && pnpm --filter @CATT_System/backend exec prisma generate \
  && pnpm --filter @CATT_System/backend build \
  && pnpm --filter @CATT_System/backend --prod deploy /pruned
RUN test -f /pruned/dist/main.js && test -f /pruned/dist/worker.js \
  && test -d /pruned/dist/generated/prisma \
  && cd /pruned && node -e "require('argon2')"

FROM deps AS build-web
COPY . .
RUN pnpm install --offline --frozen-lockfile --filter "@CATT_System/web..." \
  && pnpm --filter @CATT_System/contracts build \
  && pnpm --filter @CATT_System/web build

FROM ${NODE_IMAGE} AS runtime
WORKDIR /app
ENV NODE_ENV=production
USER node

FROM runtime AS api
COPY --from=build-backend --chown=node:node /pruned ./
EXPOSE 3000
CMD [ "node", "dist/main.js" ]

FROM runtime AS worker
COPY --from=build-backend --chown=node:node /pruned ./
CMD [ "node", "dist/worker.js" ]


FROM runtime AS web
COPY --from=build-web --chown=node:node /repo/apps/web/.output ./.output
EXPOSE 3000
CMD [ "node", ".output/server/index.mjs" ]

FROM build-backend AS migrate
WORKDIR /repo/apps/backend
CMD [ "pnpm", "exec", "prisma", "migrate", "deploy" ]
