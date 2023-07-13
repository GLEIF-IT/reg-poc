FROM gleif/keri:1.0.0

ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8

WORKDIR /usr/local/var/
RUN git clone -b regdemo https://github.com/WebOfTrust/vLEI

WORKDIR /usr/local/var/vLEI
RUN pip install -r requirements.txt

COPY ./config/vlei/samples/oobis/* /usr/local/var/vLEI/samples/oobis/

EXPOSE 7723

ENTRYPOINT [ "vLEI-server", "-s", "./schema/acdc", "-c" , "./samples/acdc/", "-o", "./samples/oobis/" ]