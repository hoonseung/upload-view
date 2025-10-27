# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# 빌드 시점에는 'public/env.js'가 그대로 dist에 복사됩니다.
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
# 빌드 결과물을 Nginx 서빙 디렉터리로 복사
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx 설정 파일이 있다면 복사 (예시)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# ------------------
# 런타임 스크립트 추가
# ------------------
COPY entrypoint.sh /entrypoint.sh

# 실행 권한 부여
RUN chmod +x /entrypoint.sh

# entrypoint 설정
ENTRYPOINT ["/entrypoint.sh"]

# Nginx 기본 CMD (entrypoint.sh의 'exec "$@"'로 실행될 명령어)
CMD ["nginx", "-g", "daemon off;"]