FROM node:12-alpine

WORKDIR /usr/app

ADD ./package*.json ./

RUN npm install

ADD ./ ./

CMD ["npm", "run", "dev"]