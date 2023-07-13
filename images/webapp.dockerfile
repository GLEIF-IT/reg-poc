FROM node:18.16.0-alpine

RUN apk update
RUN apk add bash
RUN apk add git
SHELL ["/bin/bash", "-c"]

WORKDIR /webapp
RUN git clone -b development https://github.com/GLEIF-IT/reg-poc-webapp.git .
# upgrade yarn to V2
RUN yarn set version berry
# rebuild the compiled dependencies.
RUN yarn rebuild
RUN yarn install

EXPOSE 5173

ENTRYPOINT ["yarn", "run", "compose", "--host"]
