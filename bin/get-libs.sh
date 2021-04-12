#!/usr/bin/env bash

set -e

cat ./bin/docker-get-libs.sh | docker run -i --name tmp-pg-assets amazonlinux bash

docker cp tmp-pg-assets:/to-cp/. ./local-lib/

docker container rm tmp-pg-assets
