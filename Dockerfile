# https://hub.docker.com/r/confluentinc/cp-kafka-connect - latest release on the 1st September 2024 7.4.6
FROM confluentinc/cp-kafka-connect:7.4.6

# uncomment to debug the image
USER root
# it parent image derives from a RedHat image
RUN yum -y install vim findutils

# switch back to appuser (default USER from confluentinc/cp-kafka-connect)
ARG USERNAME="appuser"
USER ${USERNAME}
ARG HOME="/home/appuser"

# ------------------------------------------------------------------------------
# Copy files and set permissions
# ------------------------------------------------------------------------------

# Copy over our start.sh script that's in our repository
# and store it in the docker user's home directory.
COPY --chmod=754 --chown=${USERNAME}:${USERNAME} start.sh ${HOME}/start.sh
COPY --chmod=754 --chown=${USERNAME}:${USERNAME} certificates-setup.sh ${HOME}/certificates-setup.sh

# ------------------------------------------------------------------------------
# Set required and default properties
# ------------------------------------------------------------------------------
ENV CONNECT_CUB_KAFKA_TIMEOUT=300
#ENV CONNECT_BOOTSTRAP_SERVERS="kafka:29092"
ENV CONNECT_REST_ADVERTISED_HOST_NAME=kafka-connect
#ENV CONNECT_REST_PORT=8083
ENV CONNECT_GROUP_ID=heroku-kafka-connect-group-01
ENV CONNECT_CONFIG_STORAGE_TOPIC=_heroku-kafka-connect-group-01-configs
ENV CONNECT_OFFSET_STORAGE_TOPIC=_heroku-kafka-connect-group-01-offsets
ENV CONNECT_STATUS_STORAGE_TOPIC=_heroku-kafka-connect-group-01-status
ENV CONNECT_KEY_CONVERTER=org.apache.kafka.connect.converters.ByteArrayConverter
ENV CONNECT_VALUE_CONVERTER=org.apache.kafka.connect.converters.ByteArrayConverter
#ENV CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL="http://schema-registry:8081"
#ENV CONNECT_INTERNAL_KEY_CONVERTER='org.apache.kafka.connect.json.JsonConverter'
#ENV CONNECT_INTERNAL_VALUE_CONVERTER='org.apache.kafka.connect.json.JsonConverter'

# https://docs.confluent.io/platform/current/connect/logging.html
#ENV CONNECT_LOG4J_ROOT_LOGLEVEL='INFO'
#ENV CONNECT_LOG4J_LOGGERS='org.apache.kafka.connect.runtime.rest=WARN,org.reflections=ERROR'
#ENV CONNECT_LOG4J_APPENDER_STDOUT_LAYOUT_CONVERSIONPATTERN="[%d] %p %X{connector.context}%m (%c:%L)%n"

ENV CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR=3
ENV CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR=3
ENV CONNECT_STATUS_STORAGE_REPLICATION_FACTOR=3
ENV CONNECT_PLUGIN_PATH='/usr/share/java,/usr/share/confluent-hub-components/,/data/connect-jars'

# ------------------------------------------------------------------------------
# Install Kafka Connect S3 Sink
# ------------------------------------------------------------------------------

# https://github.com/robcowart/cp-kafka-connect-custom - latest release on the 1st September 2024 5.4.1
RUN /bin/confluent-hub install --no-prompt confluentinc/kafka-connect-s3:5.4.1

CMD ["${HOME}/start.sh"]

