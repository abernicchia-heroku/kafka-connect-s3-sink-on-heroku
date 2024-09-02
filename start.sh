#!/usr/bin/env bash

set -e

echo "Configuring certificates"
# the dot . is required to inherit the CONNECT_ env vars exported by the script
. /home/appuser/certificates-setup.sh

# export $PORT
export CONNECT_REST_PORT="${PORT:-8083}"

# export BOOTSTRAP_SERVERS
kafka_addon_name="${KAFKA_ADDON:-KAFKA}"
kafka_url_env_var="${kafka_addon_name}_URL"

[ -z "${!kafka_url_env_var}" ] && {
  echo "ERROR: $kafka_url_env_var is missing, have you attached HEROKU KAFKA add-on to this app?" 
  exit 1
}

export CONNECT_BOOTSTRAP_SERVERS="${!kafka_url_env_var}"

echo "Launching Kafka Connect worker"
# /etc/confluent/docker/run will create /etc/kafka-connect/kafka-connect.properties from CONNECT_ env vars
/etc/confluent/docker/run

echo "Kafka Connect worker exited"