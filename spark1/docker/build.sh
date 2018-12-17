#!/usr/bin/env bash

SPARK_VERSION="1.6.3"

TAG="0.1.0-${SPARK_VERSION}"
docker build -t rg-bigdata/spark-standalone:$TAG ./