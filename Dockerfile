ARG node_version="14"

FROM node:${node_version} as build

WORKDIR /build

COPY package.json .
COPY package-lock.json .

RUN npm install

COPY . .

RUN npm run build

FROM node:${node_version}-alpine

ENV NODE_ENV="production"

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN npm install --only=production

COPY --from=build /build/dist dist

CMD ["npm", "run", "start:prod"]