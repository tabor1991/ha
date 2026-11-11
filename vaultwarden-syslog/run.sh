#!/bin/bash

CONFIG=/data/options.json

CONTAINER=$(jq -r '.container' "$CONFIG")
SYSLOG_HOST=$(jq -r '.syslog_host' "$CONFIG")
SYSLOG_PORT=$(jq -r '.syslog_port' "$CONFIG")
PROTOCOL=$(jq -r '.protocol' "$CONFIG")

echo "Starting forwarder"
echo "Container: $CONTAINER"
echo "Syslog: $SYSLOG_HOST:$SYSLOG_PORT"

SEND() {
    local line="$1"

    if [ "$PROTOCOL" = "udp" ]; then
        echo "<13>docker-vaultwarden: $line" \
          | nc -u -w1 "$SYSLOG_HOST" "$SYSLOG_PORT"
    else
        echo "<13>docker-vaultwarden: $line" \
          | nc -w1 "$SYSLOG_HOST" "$SYSLOG_PORT"
    fi
}

while true
do
    docker logs -f "$CONTAINER" 2>&1 | while read -r line
    do
        SEND "$line"
    done

    echo "Container stream closed. Reconnecting in 5s..."
    sleep 5
done
