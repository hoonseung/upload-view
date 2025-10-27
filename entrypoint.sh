#!/bin/sh

# /usr/share/nginx/html/env.js 파일을 동적으로 생성합니다.
# (Nginx 이미지의 기본 서빙 경로는 /usr/share/nginx/html 입니다. 다를 경우 수정하세요.)

echo "window.runtimeConfig = {" > /usr/share/nginx/html/env.js

# VITE_SERVER_API_URL 환경 변수가 존재하면 그 값을 사용하고,
# 없으면 'http://localhost:9898'을 기본값으로 사용합니다.
echo "  VITE_SERVER_API_URL: '${VITE_SERVER_API_URL:-http://localhost:9898}'" >> /usr/share/nginx/html/env.js

echo "};" >> /usr/share/nginx/html/env.js

echo "Generated /usr/share/nginx/html/env.js with URL: ${VITE_SERVER_API_URL:-http://localhost:9898}"

# 원래 Nginx 실행 명령어(CMD)를 실행합니다.
exec "$@"