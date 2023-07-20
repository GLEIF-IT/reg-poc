FROM node:18.16.0-alpine

RUN apk update
RUN apk add bash
RUN apk add git
SHELL ["/bin/bash", "-c"]

WORKDIR /webapp
RUN git clone https://github.com/GLEIF-IT/reg-poc-webapp.git .
RUN git checkout 5945af0d6a8c63a8654f54283ac7d1819315f95a

# Upgrade yarn to a newer version to support rebuild
RUN yarn set version berry

# Install dependencies without building by source code
RUN yarn install --mode=skip-build

# Rebuild binaries (to avoid the weird issues on windows)
# This should be ok for the POC.
RUN yarn rebuild


EXPOSE 5173

ENTRYPOINT ["yarn", "run", "compose", "--host"]