FROM node:16-alpine AS base
RUN mkdir -p /usr/app
WORKDIR /usr/app

# prepare static files
FROM base AS build-front
COPY ./ ./
RUN npm ci
RUN npm run build

# Release
FROM base As release
ENV STATIC_FILES_PATH=./public
# se cambia el origen del ordenador a la base que tenemos señalada
COPY --from=build-front /usr/app/dist  $STATIC_FILES_PATH
COPY ./server/package.json ./
COPY ./server/package-lock.json ./
COPY ./server/index.js ./

RUN npm ci --only=production

ENV PORT=8080
CMD node index.js
