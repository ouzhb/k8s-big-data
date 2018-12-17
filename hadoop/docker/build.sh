#!/usr/bin/env bash

HADOOP_VERSION="2.7.7"
TAG="0.1.0-${HADOOP_VERSION}"
docker build -t rg-bigdata/hadoop-hdfs:$TAG ./