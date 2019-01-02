#!/bin/sh -e


#url="${mirror}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
#url="http://192.168.23.163:88/kafka_2.11-0.9.0.1.tgz"
url1="https://www.apache.org/dyn/closer.cgi?path=/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
url2="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"

wget -q "${url2}" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" 
#wget -q "${url2}" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"

