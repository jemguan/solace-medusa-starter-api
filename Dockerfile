FROM node:20

WORKDIR /app/medusa

# 复制 package.json 和 yarn.lock
COPY package.json yarn.lock ./

# 启用 yarn 3.2.3
RUN corepack enable && \
    corepack prepare yarn@3.2.3 --activate && \
    yarn set version 3.2.3

# 安装依赖
RUN apt-get update && \
    apt-get install -y python3 python3-pip python-is-python3

# 安装依赖
RUN yarn install

# 复制所有源代码
COPY . .

# 构建后端和 admin UI
RUN yarn build && \
    yarn cache clean

# 设置环境变量
ENV NODE_ENV=production

# 启动命令：迁移数据库和启动服务
CMD yarn db:migrate && yarn start
