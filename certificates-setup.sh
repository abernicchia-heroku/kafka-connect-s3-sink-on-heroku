#!/usr/bin/env bash

set -e

kafka_addon_name=${KAFKA_ADDON:-KAFKA}

client_key="${kafka_addon_name}_CLIENT_CERT_KEY"
client_cert="${kafka_addon_name}_CLIENT_CERT"
trusted_cert="${kafka_addon_name}_TRUSTED_CERT"

[ -z "${!client_key}" ] && {
  echo "ERROR: $client_key is missing, have you attached HEROKU KAFKA add-on to this app?" >&2
  exit 1
}

[ -z "${!client_cert}" ] && {
  echo "ERROR: $client_cert is missing, have you attached HEROKU KAFKA add-on to this app?" >&2
  exit 1
}

[ -z "${!trusted_cert}" ] && {
  echo "ERROR: $trusted_cert is missing, have you attached HEROKU KAFKA add-on to this app?" >&2
  exit 1
}

[ -z "$TRUSTSTORE_PASSWORD" ] && {
  echo "ERROR: TRUSTSTORE_PASSWORD is missing" >&2
  exit 1
}

[ -z "$KEYSTORE_PASSWORD" ] && {
  echo "ERROR: KEYSTORE_PASSWORD is missing" >&2
  exit 1
}

rm -f client.key client.crt ca.crt kafka.client.keystore.jks kafka.client.truststore.jks client.p12

echo -n "${!client_key}" > client.key
echo -n "${!client_cert}" > client.crt
echo -n "${!trusted_cert}" > ca.crt

openssl pkcs12 -export -in client.crt -inkey client.key -out client.p12 -password pass:$KEYSTORE_PASSWORD

keytool -importkeystore -srckeystore client.p12 -srcstorepass $KEYSTORE_PASSWORD -destkeystore kafka.client.keystore.jks -deststorepass $KEYSTORE_PASSWORD -srcstoretype pkcs12

keytool -keystore kafka.client.truststore.jks -alias CARoot -import -file ca.crt -deststorepass $TRUSTSTORE_PASSWORD -noprompt

rm -f client.key client.crt ca.crt client.p12

export CONNECT_CONSUMER_SECURITY_PROTOCOL=SSL
export CONNECT_CONSUMER_SSL_KEYSTORE_LOCATION=$HOME/kafka.client.keystore.jks
export CONNECT_CONSUMER_SSL_KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_CONSUMER_SSL_TRUSTSTORE_LOCATION=$HOME/kafka.client.truststore.jks
export CONNECT_CONSUMER_SSL_TRUSTSTORE_PASSWORD=$TRUSTSTORE_PASSWORD
#export CONNECT_CONSUMER_SSL_KEY_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_CONSUMER_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM=

export CONNECT_SECURITY_PROTOCOL=SSL
export CONNECT_SSL_KEYSTORE_LOCATION=$HOME/kafka.client.keystore.jks
export CONNECT_SSL_KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_SSL_TRUSTSTORE_LOCATION=$HOME/kafka.client.truststore.jks
export CONNECT_SSL_TRUSTSTORE_PASSWORD=$TRUSTSTORE_PASSWORD
#export CONNECT_SSL_KEY_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM=
