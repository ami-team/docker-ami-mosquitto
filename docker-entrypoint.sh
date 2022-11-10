#!/bin/ash
set -e

if [ ! -f /mosquitto/config/mosquitto.conf ]
then
	cp /mosquitto/mosquitto.conf.orig /mosquitto/config/mosquitto.conf
fi

# Set permissions
user="$(id -u)"

if [ "$user" = '0' ]
then
	[ -d "/mosquitto" ] && chown -R mosquitto:mosquitto /mosquitto || true
fi

exec "$@"
