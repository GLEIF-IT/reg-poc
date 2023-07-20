FROM python:3.10.4-alpine3.16

RUN apk update
RUN apk add bash
RUN apk add git
SHELL ["/bin/bash", "-c"]

WORKDIR /server

RUN git clone https://github.com/GLEIF-IT/reg-poc-server.git .
RUN git checkout 7e59cb62454e37bd5ce941d84b78075e9c7d24fa

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /server/src/regps
ENV KERI_AGENT_CORS=true

ENTRYPOINT [ "gunicorn", "-b", "server:8000", "app:app"]