# Multi-stage build.
#
# Stage 1 installs dependencies and produces dist/ exactly the way CI does.
# Stage 2 copies only the built output into a tiny runtime image.
# This is what we point at when we explain "build once, ship the same artifact".

# ---------- build stage ----------
FROM node:22-alpine AS build
WORKDIR /app

# Copy manifests first so Docker can cache the install layer.
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev || npm install --omit=dev

COPY . .
RUN npm run build

# ---------- runtime stage ----------
FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

COPY --from=build /app/dist ./dist
COPY --from=build /app/scripts/serve.js ./scripts/serve.js
COPY --from=build /app/package.json ./package.json

# Never run as root inside a container.
USER node

EXPOSE 3000
CMD ["node", "scripts/serve.js"]
