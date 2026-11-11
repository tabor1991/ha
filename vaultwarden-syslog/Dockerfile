FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    docker-cli \
    netcat-openbsd \
    jq

COPY run.sh /run.sh

RUN chmod +x /run.sh

CMD ["/run.sh"]
