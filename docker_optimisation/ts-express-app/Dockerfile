# unoptimised Dockerfile 

# baseimage
FROM node:lts
WORKDIR /app
COPY . .
RUN yarn install
# Build
RUN yarn build
CMD ["node", "dist/index.js"]
EXPOSE 3000
