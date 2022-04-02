########################################################################################################################

FROM eclipse-mosquitto:2

########################################################################################################################

LABEL maintainer="Jérôme ODIER <jerome.odier@lpsc.in2p3.fr>"

LABEL description="AMI Mosquitto Server"

########################################################################################################################

RUN apk add --update --no-cache gcc
RUN apk add --update --no-cache git
RUN apk add --update --no-cache bash
RUN apk add --update --no-cache make
RUN apk add --update --no-cache cmake
RUN apk add --update --no-cache libc-dev

########################################################################################################################

RUN wget -O /usr/include/mosquitto.h https://raw.githubusercontent.com/eclipse/mosquitto/v${VERSION}/include/mosquitto.h
RUN wget -O /usr/include/mosquitto_broker.h https://raw.githubusercontent.com/eclipse/mosquitto/v${VERSION}/include/mosquitto_broker.h
RUN wget -O /usr/include/mosquitto_plugin.h https://raw.githubusercontent.com/eclipse/mosquitto/v${VERSION}/include/mosquitto_plugin.h

########################################################################################################################

RUN ( git clone https://github.com/odier-io/mosquitto-ip-jwt-auth.git /mosquitto-ip-jwt-auth/ && cd /mosquitto-ip-jwt-auth/ && make deps all && cp ./ip-jwt-auth.so /ip-jwt-auth.so )

RUN rm -fr /mosquitto-ip-jwt-auth/

########################################################################################################################

EXPOSE 1883

########################################################################################################################
