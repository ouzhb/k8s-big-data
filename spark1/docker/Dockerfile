FROM centos:7.5.1804

MAINTAINER RuijieBigdata

ARG SPARK_FILE_NAME="spark-1.6.3-bin-with-hadoop-2.7.7"
ARG JAVA_FILE_NAME="jdk-8u152-linux-x64.rpm"

USER root

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    mkdir -p /usr/share/man/man1/

# java
ADD packages/${JAVA_FILE_NAME} /opt/ruijie/install/${JAVA_FILE_NAME}
RUN rpm -i /opt/ruijie/install/${JAVA_FILE_NAME} && rm /opt/ruijie/install/${JAVA_FILE_NAME}

ENV JAVA_HOME /usr/java/default
RUN rm /usr/bin/java && ln -s $JAVA_HOME/bin/java /usr/bin/java

# Spark
COPY packages/${SPARK_FILE_NAME}.tgz /opt/ruijie/install/${SPARK_FILE_NAME}.tgz
RUN tar -zxf /opt/ruijie/install/${SPARK_FILE_NAME}.tgz -C /usr/local; \
    cd /usr/local && ln -s ./${SPARK_FILE_NAME} spark; \
    rm /opt/ruijie/install/${SPARK_FILE_NAME}.tgz; \
    chown -R root:root /usr/local/spark/;
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$JAVA_HOME/bin:$SPARK_HOME/bin

