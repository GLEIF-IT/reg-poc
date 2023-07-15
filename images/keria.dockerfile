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
RUN git checkout c3a6fc455b5fac194aa9c264e48ea2c52328d4c5
RUN source "$HOME/.cargo/env" && pip install -r requirements.txt

WORKDIR /keria
RUN git clone https://github.com/WebOfTrust/keria.git .
RUN git checkout d3a73741d97c0e9f52f10e01e9d89025aa99f9ff
RUN pip install -r requirements.txt

WORKDIR /keripy
RUN pip install -e .

WORKDIR /keria
RUN mkdir -p /keria/scripts/keri/cf
COPY ./config/keria/scripts/keri/cf/demo-witness-oobis.json /keria/scripts/keri/cf/demo-witness-oobis.json

EXPOSE 3901
EXPOSE 3902
EXPOSE 3903

ENV KERI_AGENT_CORS=true

ENTRYPOINT ["keria", "start",  "--config-file", "demo-witness-oobis", "--config-dir", "./scripts"]


