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
CMD ["node","index.js"]


