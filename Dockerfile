FROM node:latest

WORKDIR /app/medusa

COPY . .

RUN corepack enable && \
    corepack prepare yarn@3.2.3 --activate && \
    yarn set version 3.2.3

RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3

RUN yarn install

RUN yarn build
RUN yarn build:admin

CMD yarn db:migrate && yarn start
