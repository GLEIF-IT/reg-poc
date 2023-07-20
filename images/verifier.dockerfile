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
RUN git clone -b development https://github.com/WebOfTrust/keripy.git .
RUN git checkout 4185296affb2348d19af6009be04f682a3e19360
RUN source "$HOME/.cargo/env" && pip install -r requirements.txt

RUN mkdir -p /usr/local/var/keri

WORKDIR /verifier
RUN git clone https://github.com/GLEIF-IT/reg-poc-verifier.git .
RUN git checkout ee76780c1d225c7ad3a0806319fc4544f870e245
RUN pip install -r requirements.txt

WORKDIR /keripy
RUN pip install -e .

WORKDIR /verifier
RUN mkdir -p /verifier/scripts/keri/cf/

COPY ./config/verifier/verifier-config.json /verifier/scripts/keri/cf/verifier-config.json

ENTRYPOINT ["verifier", "server", "start", "--config-dir", "scripts", "--config-file", "verifier-config.json"]
