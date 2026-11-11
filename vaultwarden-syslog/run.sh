#!/bin/bash

CONFIG="/data/options.json"

CONTAINER=$(jq -r '.container' "$CONFIG")
SYSLOG_HOST=$(jq -r '.syslog_host' "$CONFIG")
SYSLOG_PORT=$(jq -r '.syslog_port' "$CONFIG")
PROTOCOL=$(jq -r '.protocol' "$CONFIG")
TAG=$(jq -r '.tag' "$CONFIG")
RECONNECT_DELAY=$(jq -r '.reconnect_delay' "$CONFIG")

echo "Starting Vaultwarden Syslog Forwarder"
echo "Container: $CONTAINER"
echo "Syslog: $SYSLOG_HOST:$SYSLOG_PORT"
echo "Protocol: $PROTOCOL"

while true
do
    docker logs --since=5s -f "$CONTAINER" 2>&1 | while read -r line
    do
        if [ "$PROTOCOL" = "udp" ]; then
            echo "<13>${TAG}: $line" \
                | nc -u -w1 "$SYSLOG_HOST" "$SYSLOG_PORT"
        else
            echo "<13>${TAG}: $line" \
                | nc -w1 "$SYSLOG_HOST" "$SYSLOG_PORT"
        fi
    done

    echo "Log stream disconnected. Reconnecting in ${RECONNECT_DELAY}s..."
    sleep "$RECONNECT_DELAY"
done
