FROM node:18.16.0-alpine

RUN apk update
RUN apk add bash
RUN apk add git
SHELL ["/bin/bash", "-c"]

WORKDIR /webapp
RUN git clone -b regdemo https://github.com/GLEIF-IT/reg-poc-webapp.git .

EXPOSE 5173

RUN yarn install

ENTRYPOINT ["yarn", "run", "compose", "--host"]
