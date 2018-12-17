#!/usr/bin/env bash

SPARK_VERSION="1.6.3"

TAG="0.1.0-${SPARK_VERSION}"

SPARK_FILE_NAME="spark-1.6.3-bin-with-hadoop-2.7.7"
JAVA_FILE_NAME="jdk-8u191-linux-x64"
tar -xvf packages/${SPARK_FILE_NAME}.tgz && mv ${SPARK_FILE_NAME} spark
tar -xvf packages/${JAVA_FILE_NAME}.tar.gz

docker build -t rg-bigdata/spark-standalone:$TAG ./

rm -rf jdk1.8.0_191/
rm -rf spark/