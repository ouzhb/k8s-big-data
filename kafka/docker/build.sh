#!/usr/bin/env bash

KAFKA_VERSION="1.1.1"
TAG="0.1.0-${KAFKA_VERSION}"
docker build -t rg-bigdata/kafka:$TAG ./