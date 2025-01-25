FROM node:latest

WORKDIR /app/medusa

COPY . .

RUN corepack enable && \
    corepack prepare yarn@3.2.3 --activate && \
    yarn set version 3.2.3

RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3

RUN yarn install

# 构建后端
RUN yarn build

# 禁用遥测
RUN yarn medusa telemetry --disable

CMD yarn db:migrate && yarn start
