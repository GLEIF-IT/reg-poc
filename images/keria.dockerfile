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
RUN source "$HOME/.cargo/env" && pip install -r requirements.txt

WORKDIR /keria
RUN git clone https://github.com/WebOfTrust/keria.git .
RUN pip install -r requirements.txt

WORKDIR /keripy
RUN pip install -e .
WORKDIR /keria

COPY ./config/keria/scripts/* ./scripts

EXPOSE 3901
EXPOSE 3902
EXPOSE 3903

ENV KERI_AGENT_CORS=false

RUN mkdir -p /usr/local/var/keri
COPY ./data/keri/* /usr/local/var/keri
RUN export KERI_AGENT_CORS=true

ENTRYPOINT ["keria", "start",  "--config-file", "demo-witness-oobis", "--config-dir", "./scripts"]


