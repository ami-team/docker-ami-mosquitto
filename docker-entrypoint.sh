#!/bin/ash
set -e

if [ ! -f /mosquitto/config/mosquitto.conf ]
then
  RAND_SECRET=$(cat /dev/urandom | fold -w 128 | md5 | fold -w 16 | head -n 1)

  cat > mosquitto/config/mosquitto.conf << EOF
plugin /ip-jwt-auth.so

plugin_opt_jwt_signing_alg HS512
plugin_opt_jwt_secret_key ${JWT_SECRET:-${RAND_SECRET}}
plugin_opt_jwt_issuer ${JWT_ISSUER:-AMI}

listener 1883
protocol mqtt

listener 9001
protocol websockets

allow_anonymous false

$(cat /mosquitto/mosquitto.conf.orig)
EOF
fi

# Set permissions
user="$(id -u)"

if [ "$user" = '0' ]
then
	[ -d "/mosquitto" ] && chown -R mosquitto:mosquitto /mosquitto || true
fi

exec "$@"
