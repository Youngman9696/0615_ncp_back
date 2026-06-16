FROM node:24-slim

WORKDIR /app

COPY package*.json ./

RUN npm install -y

# 현재 디렉토리의 모든 파일(src, uploads, deploy 폴더 등) 컨테이너의 /app 폴더로 복사
COPY . . 

EXPOSE 3000

CMD ["npm", "start"]