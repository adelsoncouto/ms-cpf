FROM alpine:3.8
LABEL maintainer="Adelson Silva Couto <adscouto@gmail.com>"

RUN mkdir -p /usr/src \
  && apk add --no-cache bash \
  && mkfifo /usr/src/req

COPY ./index.sh /usr/src/index.sh

RUN chmod +x /usr/src/index.sh

WORKDIR /usr/src

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/bin/sh","-c","while true; do nc -l -s 0.0.0.0 -p 80 0</usr/src/req | /usr/src/index.sh 1>/usr/src/req;done"]
