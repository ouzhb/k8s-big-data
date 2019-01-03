#FROM openjdk:8u151-jre-alpine
FROM rg-bigdata/rg-base:0.0.1
LABEL maintainer "Ruijie BD Team"
ARG kafka_version=1.1.1
ARG scala_version=2.11

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka

ENV PATH=${PATH}:${KAFKA_HOME}/bin
#
COPY download-kafka.sh create-topics.sh kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz /tmp/

RUN mkdir /init \
 && chmod a+x /init/ \
 && chmod a+x /tmp/*.sh \
 && mv /tmp/create-topics.sh /usr/bin \
 && sync \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
 && rm /tmp/* \
 && apt-get update \
 && apt install -y tzdata curl --no-install-recommends \
 && rm -rf /etc/localtime \
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && rm -rf /var/lib/apt/lists/*

