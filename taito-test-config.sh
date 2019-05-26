#!/bin/bash
# shellcheck disable=SC2034

# NOTE: Variable is passed to the test without the test_TARGET_ prefix

# URLs
test_www_CYPRESS_baseUrl=$ci_test_base_url
if [[ "$taito_target_env" == "local" ]]; then
  CYPRESS_baseUrl=$taito_app_url
else
  CYPRESS_baseUrl=$ci_test_base_url
fi

# Hack to avoid basic auth on Electron browser startup:
# https://github.com/cypress-io/cypress/issues/1639
CYPRESS_baseUrlHack=$CYPRESS_baseUrl
CYPRESS_baseUrl=https://www.google.com
test_www_CYPRESS_baseUrlHack=$test_client_CYPRESS_baseUrl
test_www_CYPRESS_baseUrl=https://www.google.com
