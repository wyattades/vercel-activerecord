#!/usr/bin/env bash

if ! cat /etc/os-release | grep "Amazon Linux"; then
  echo "Skipping build in development"
  exit 0
fi

set -x

pwd

amazon-linux-extras enable postgresql11
yum install libpq-devel -y

libpq11=$(find / -name libpq.so.5.11)
libpq5=$(find / -name libpq.so.5)
libpq=$(find / -name libpq.so)
echo "$libpq ---  $libpq5 --- $libpq11"

ls -la $(dirname $libpq) | grep pq

pg_config_path=$(find / -name pg_config)
bundle config build.pg --with-pg-config=$pg_config_path
bundler install --deployment

echo "asdasdas" >./local-lib/foobar.txt

cp $libpq ./local-lib/libpq.so.5
ls -la ./local-lib

echo "$LD_LIBRARY_PATH"
