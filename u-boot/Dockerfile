FROM alpine:3.24.2

ENV ARCH=arm64

ARG PACKAGES="arm-trusted-firmware alpine-sdk bash build-base bc bison dtc flex gnutls-dev linux-headers ncurses-dev \
  openssl-dev py3-elftools py3-setuptools python3-dev sdl2-dev swig util-linux-dev"

RUN apk add ${PACKAGES} --no-cache

COPY --chown=root --chmod=555 ./build_androidbootimage.sh /usr/bin/build_androidbootimage