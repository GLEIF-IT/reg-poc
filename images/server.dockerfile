FROM python:3.10.4-alpine3.16

RUN apk update
RUN apk add bash
RUN apk add git
SHELL ["/bin/bash", "-c"]

WORKDIR /server

RUN git clone https://github.com/GLEIF-IT/reg-poc-server.git .
RUN git checkout 46c2cf7a749cb2f3493e4752fb0faf970e6db3b0

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /server/src/regps
ENV KERI_AGENT_CORS=true

ENTRYPOINT [ "gunicorn", "-b", "server:8000", "app:app"]