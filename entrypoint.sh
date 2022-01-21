#!/bin/sh

set -e

if [[ "$1" ]]; then
  echo "Running: $@"
  eval "$@"
else

  if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
  fi

  bundle exec rails s -b 0.0.0.0
fi
