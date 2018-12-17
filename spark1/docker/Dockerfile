FROM centos:7.5.1804

MAINTAINER RuijieBigdata

USER root

# java
COPY jdk1.8.0_191/ /usr/java/jdk1.8.0_191/
COPY spark/ /usr/local/spark/

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    ln -sf /usr/java/jdk1.8.0_191 /usr/java/default;

ENV JAVA_HOME /usr/java/default
ENV JRE_HOME /usr/java/latest/jre
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$SPARK_HOME/bin

