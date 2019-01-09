#FROM openjdk:8u151-jre-alpine
FROM rg-bigdata/rg-base:0.0.1
ARG hbase_version=2.1.2

ENV HBASE_HOME /usr/local/hbase
ENV PATH ${PATH}:${HBASE_HOME}/bin
#
COPY  hbase-${hbase_version}-bin.tar.gz /usr/local/hbase-${hbase_version}-bin.tar.gz

RUN tar -xvf /usr/local/hbase-${hbase_version}-bin.tar.gz -C /usr/local/ \
    && rm /usr/local/hbase-${hbase_version}-bin.tar.gz \
    && ln -s /usr/local/hbase-${hbase_version} /usr/local/hbase \
    && chown -R root:root /usr/local/hbase/ \
    && apt-get update \
    && apt install -y tzdata curl --no-install-recommends \
    && rm -rf /etc/localtime \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/lib/apt/lists/*

