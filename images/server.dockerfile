FROM python:3.10.4-alpine3.16

RUN apk update
RUN apk add bash
RUN apk add git
SHELL ["/bin/bash", "-c"]

WORKDIR /server
RUN git checkout https://github.com/GLEIF-IT/reg-poc-server.git .

WORKDIR /server/src/regps

ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8000", "app:app", "--reload"]


