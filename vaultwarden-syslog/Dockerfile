ARG BUILD_FROM=alpine:3.22
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    bash \
    docker-cli \
    jq \
    netcat-openbsd

COPY run.sh /run.sh

RUN chmod +x /run.sh

CMD ["/run.sh"]
