#!/usr/bin/env bash

HBASE_VERSION="2.1.2"
TAG="0.1.0-${HBASE_VERSION}"
docker build -t rg-bigdata/hbase:$TAG ./