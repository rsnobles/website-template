#!/bin/sh

set -xe

cd /service/repository/www
if [ "${1}" = "install" ]; then
  git clone "https://${WEBHOOK_GIT_TOKEN}@${GIT_REPOSITORY_URL}" repository
  git checkout "${COMMON_ENV}"
  npm run install-site
fi
git pull
npm run build
