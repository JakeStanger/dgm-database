FROM node:14.17.0-alpine as builder

WORKDIR /app

RUN apk --no-cache upgrade && apk add yarn

COPY ./package.json package.json
COPY ./yarn.lock yarn.lock
COPY prisma prisma

RUN yarn install --frozen-lockfile
RUN yarn prisma generate

COPY . .

RUN yarn build

FROM node:alpine

RUN apk --no-cache upgrade && apk add curl

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/yarn.lock ./yarn.lock
COPY --from=builder /app/lib ./lib

EXPOSE 3000

HEALTHCHECK --interval=60s --timeout=3s CMD curl --fail http://localhost:3000 || exit 1

ENTRYPOINT ["yarn", "start"]