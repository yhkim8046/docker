#베이스 이미지 설정
FROM node:lts-alpine

#작업 디렉토리 설정
WORKDIR /app

#파일 복사
COPY . .

#패키 설치
RUN yarn install --production

#애플리케이션 설치
CMD ["node", "src/index.js"]

#포트 노출
EXPOSE 3000