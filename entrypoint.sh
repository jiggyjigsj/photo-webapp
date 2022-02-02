#!/bin/sh

set -e
if [[ "$1" == "worker" ]]; then
  source .env
  bundle exec bundle exec ruby worker/worker.rb
elif [[ "$1" ]]; then
  echo "Running: $@"
  eval "$@"
else

  if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
  fi
  source .env
  bundle exec rake db:migrate
  bundle exec rails s -b 0.0.0.0
fi
