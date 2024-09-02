#!/usr/bin/env bash

set -e

echo "Configuring certificates"
# the dot . is required to inherit the CONNECT_ env vars exported by the script
. /home/appuser/certificates-setup.sh

kafka_addon_name="${KAFKA_ADDON:-KAFKA}"
kafka_url_env_var="${kafka_addon_name}_URL"

[ -z "${!kafka_url_env_var}" ] && {
  echo "ERROR: $kafka_url_env_var is missing, have you attached HEROKU KAFKA add-on to this app?" 
  exit 1
}

# export BOOTSTRAP_SERVERS
export CONNECT_BOOTSTRAP_SERVERS="${!kafka_url_env_var}"

# export REST and ADVERTISED hostname/port required by Kafka Connect
# https://docs.confluent.io/platform/current/installation/docker/config-reference.html#required-kconnect-long-configurations
# https://devcenter.heroku.com/articles/dyno-dns-service-discovery#environment-variables
export CONNECT_REST_ADVERTISED_HOST_NAME="${HEROKU_DNS_DYNO_NAME}"
export CONNECT_REST_ADVERTISED_PORT=2020
export CONNECT_LISTENERS="HTTP://0.0.0.0:${PORT},HTTP://0.0.0.0:2020"
export CONNECT_REST_PORT="${PORT}"

echo "Launching Kafka Connect worker"
# /etc/confluent/docker/run will create /etc/kafka-connect/kafka-connect.properties from CONNECT_ env vars
/etc/confluent/docker/run

echo "Kafka Connect worker exited"