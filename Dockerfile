# Base image 
FROM node:lt
WORKDIR /app
COPY . .

# install packges
RUN yarn install --production

# implement
CMD ["node", "src/index.js"]

EXPOSE 3000
