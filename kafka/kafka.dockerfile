FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools
RUN apt-get update && apt-get install -y \
    wget \
    net-tools \
    iputils-ping \
    vim \
    nano \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Java 11
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Install Kafka
ARG KAFKA_VERSION=3.6.1
ARG SCALA_VERSION=2.13

RUN wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O /tmp/kafka.tgz \
    && tar -xvzf /tmp/kafka.tgz -C /opt \
    && rm /tmp/kafka.tgz \
    && mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

# Set environment variables
ENV KAFKA_HOME /opt/kafka
ENV PATH $PATH:$KAFKA_HOME/bin

# Create Kafka data directory
RUN mkdir -p /var/lib/kafka/data

# Generate a random cluster id
RUN kafka-storage.sh format -t $(kafka-storage.sh random-uuid) -c /opt/kafka/config/kraft/server.properties

# Create a volume for Kafka data
VOLUME /var/lib/kafka/data

# Expose ports
EXPOSE 9092

# Start Kafka
CMD ["kafka-server-start.sh", "/opt/kafka/config/kraft/server.properties"]
