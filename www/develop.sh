#!/bin/sh

set -x

if [ ! -d ./site ]; then
  # No site yet. Just keep container running.
  tail -f /dev/null
elif [ -f ./site/package.json ]; then
  # Gatsby development
  cd /service/site && \
  npm install && \
  npm run develop
elif [ -f ./site/Gemfile ]; then
  # Jekyll development
  cd /service/site && \
  bundle exec jekyll serve --host 0.0.0.0 --port 8080
else
  # Hugo development
  cd /service/site && \
  hugo server -D --bind=0.0.0.0 --port 8080 --baseUrl http://localhost:9999
fi

# TODO configure live reload for all of these
