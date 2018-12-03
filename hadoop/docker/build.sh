#!/usr/bin/env bash

HADOOP_VERSION="2.7.7"
TAG="0.1.0-${HADOOP_VERSION}"
docker build -t harbor.mig.ruijie.net/rgibns-snapshot/hadoop-hdfs:$TAG ./