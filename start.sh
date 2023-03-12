#!/bin/bash

set -o errexit

user=$(
  python -c '
import yaml;
print(
    yaml.safe_load(
        open("../../david-caro/home-lab-secrets/home_automation/expenses/db_config.yaml")
    )["DB_USERNAME"]
);
'
)
pass=$(
  python -c '
import yaml;
print(
    yaml.safe_load(
        open("../../david-caro/home-lab-secrets/home_automation/expenses/db_config.yaml")
    )["DB_PASSWORD"]
);
'
)
host=$(
  python -c '
import yaml;
print(
    yaml.safe_load(
        open("../../david-caro/home-lab-secrets/home_automation/expenses/db_config.yaml")
    )["DB_HOST"]
);
'
)

podman run \
    --publish 8080:8080 \
    --detach \
    --name expenses_app_dev \
    -e "DB_USERNAME=$user" \
    -e "DB_PASSWORD=$pass" \
    -e "DB_HOST=$host" \
    expenses-app:dev-latest
