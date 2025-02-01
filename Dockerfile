FROM node:20

WORKDIR /app/medusa

# 复制 package.json 和 yarn.lock
COPY package.json yarn.lock ./

# 启用 yarn 3.2.3 并安装依赖
RUN corepack enable && \
    corepack prepare yarn@3.2.3 --activate && \
    yarn set version 3.2.3 && \
    yarn config set nodeLinker node-modules && \
    yarn install --frozen-lockfile

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y python3 python3-pip python-is-python3

# 复制所有源代码
COPY . .

# 构建后端和 admin UI
RUN yarn build && \
    mkdir -p .medusa/admin && \
    cp -r node_modules/@medusajs/admin-ui/dist/* .medusa/admin/ && \
    cp node_modules/@medusajs/admin-ui/dist/index.html .medusa/admin/

# 清理不必要的文件
RUN yarn cache clean && \
    rm -rf /var/lib/apt/lists/*

# 设置环境变量
ENV NODE_ENV=production

# 启动命令
CMD yarn db:migrate && yarn start
