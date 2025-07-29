########## build stage ##########
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .

########## runtime stage ##########
FROM node:20-alpine
WORKDIR /app
ENV PORT=4000
COPY --from=build /app .
EXPOSE 4000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:4000/health || exit 1
CMD ["node","index.js"]


