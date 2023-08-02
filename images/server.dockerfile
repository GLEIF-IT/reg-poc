FROM python:3.10.4-alpine3.16

RUN apk update
RUN apk add bash
SHELL ["/bin/bash", "-c"]

RUN apk add alpine-sdk
RUN apk add libffi-dev
RUN apk add libsodium
RUN apk add libsodium-dev
RUN apk add git

# Setup Rust for blake3 dependency build
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

WORKDIR /keripy
RUN git clone -b development https://github.com/WebOfTrust/keripy.git .
RUN git checkout 4185296affb2348d19af6009be04f682a3e19360

RUN source "$HOME/.cargo/env" && pip install -r requirements.txt

WORKDIR /server
RUN git clone https://github.com/GLEIF-IT/reg-poc-server.git .
RUN git checkout 26a675397e7b3000aeb5dfa7d17fe73026b49a6c

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /server/src/regps
ENV KERI_AGENT_CORS=true

ENTRYPOINT [ "gunicorn", "-b", "server:8000", "app:app"]
