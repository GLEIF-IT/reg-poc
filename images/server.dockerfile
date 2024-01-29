FROM python:3.10.4-alpine3.16

RUN apk update
RUN apk add bash
RUN apk add git
SHELL ["/bin/bash", "-c"]

RUN apk add alpine-sdk
RUN apk add libffi-dev
RUN apk add libsodium
RUN apk add libsodium-dev
RUN apk add git

# Setup Rust for blake3 dependency build
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

WORKDIR /keripy
RUN git clone -b reg-poc-demo https://github.com/WebOfTrust/keripy.git .
RUN source "$HOME/.cargo/env" && pip install -r requirements.txt

RUN mkdir -p /usr/local/var/keri

WORKDIR /server

RUN git clone -b main https://github.com/GLEIF-IT/reg-poc-server.git .

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /server/src/regps
ENV KERI_AGENT_CORS=true

ENTRYPOINT [ "gunicorn", "-b", "server:8000", "app:app"]