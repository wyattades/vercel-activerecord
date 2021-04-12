#!/usr/bin/env bash

if ! cat /etc/os-release | grep "Amazon Linux"; then
  echo "Skipping build in development"
  exit 0
fi

trap 'echo "# $(date) $BASH_COMMAND"' DEBUG

amazon-linux-extras enable postgresql11
yum install libpq-devel -y

pg_config_path=$(find / -name pg_config)
bundle config build.pg --with-pg-config=$pg_config_path
bundler install --deployment
