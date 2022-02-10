#!/bin/bash
set -e

checkenv() {
  VARS=(RAILS_ADAPTER RAILS_DB RAILS_DB_USERNAME RAILS_DB_PASSWORD RAILS_DB_PORT RAILS_DB_HOST GCP_PROJECT_ID GCP_CLOUD_STORAGE_BUCKET GCP_CLOUD_PUB_SUB GCP_CREDENTIALS_FILE)
  for var in ${VARS[@]}
  do
    if [ -z "${!var}" ]; then
      echo "[ERROR] ${var} is unset!"
      trigger=1
    fi
  done
  if [[ ! -f "${GCP_CREDENTIALS_FILE}" ]]; then
    echo "${GCP_CREDENTIALS_FILE}  doesn't exists."
    trigger=1
  fi
  if [[ ${trigger} ]]; then
    exit 1
  fi
}

if [[ "$1" == "worker" ]]; then
  source .env && checkenv
  bundle exec bundle exec ruby worker/worker.rb
elif [[ "$1" ]]; then
  echo "Running: $@"
  eval "$@"
else
  echo "Starting the Front End App."
  echo "To Start Backend/Worker, run this with \`worker\` as a command!"
  echo "IE: docker run ghcr.io/jiggyjigsj/photo-webapp/photonic worker"

  if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
  fi

  source .env && checkenv
  bundle exec rake db:migrate
  bundle exec rails s -b 0.0.0.0
fi
