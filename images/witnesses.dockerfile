
FROM python:3.10.4-alpine3.16

RUN apk update
RUN apk add bash
SHELL ["/bin/bash", "-c"]

RUN apk add alpine-sdk
RUN apk add libffi-dev
RUN apk add libsodium
RUN apk add libsodium-dev

# Setup Rust for blake3 dependency build
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

WORKDIR /keripy
RUN git clone -b reg-poc-demo https://github.com/WebOfTrust/keripy.git .
RUN source "$HOME/.cargo/env" && pip install -r requirements.txt

RUN mkdir -p /keripy/scripts/keri/cf/main
COPY ./config/witnesses/*.json /keripy/scripts/keri/cf/main/
RUN mkdir -p /usr/local/var/keri
COPY ./data/keri /usr/local/var/keri/

EXPOSE 5632
EXPOSE 5633
EXPOSE 5634
EXPOSE 5642
EXPOSE 5643
EXPOSE 5644

ENTRYPOINT ["kli", "witness", "demo"]
