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

# 启动命令：先迁移数据库，创建管理员用户，然后启动服务
CMD yarn db:migrate && medusa user -e admin@example.com -p admin123456 && yarn start
