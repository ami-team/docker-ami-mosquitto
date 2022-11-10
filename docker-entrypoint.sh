#!/bin/ash
set -e

if [ ! -f /mosquitto/config/mosquitto.conf ]
then
  if [ -n "${JWT_SECRET}" ] && [ -n "${JWT_ISSUER}" ]
  then
    ####################################################################################################################

    cat > mosquitto/config/mosquitto.conf << EOF
plugin /ip-jwt-auth.so

plugin_opt_jwt_signing_alg HS512
plugin_opt_jwt_secret_key ${JWT_SECRET}
plugin_opt_jwt_issuer ${JWT_ISSUER}

listener 1883
protocol mqtt

listener 9001
protocol websockets

allow_anonymous false

$(cat /mosquitto/mosquitto.conf.orig)
EOF

    ####################################################################################################################
  else
    ####################################################################################################################

    cat > mosquitto/config/mosquitto.conf << EOF
listener 1883
protocol mqtt

listener 9001
protocol websockets

allow_anonymous true

$(cat /mosquitto/mosquitto.conf.orig)
EOF

    ####################################################################################################################
  fi
fi

# Set permissions
user="$(id -u)"

if [ "$user" = '0' ]
then
	[ -d "/mosquitto" ] && chown -R mosquitto:mosquitto /mosquitto || true
fi

exec "$@"
