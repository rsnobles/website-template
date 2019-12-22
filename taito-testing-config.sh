#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154

##########################################################################
# Testing settings
#
# NOTE: Variables are passed to the tests without the test_TARGET_ prefix.
##########################################################################

# Environment specific settings
if [[ $taito_env == "local" ]]; then
  ci_test_base_url=http://website-template-ingress:80
elif [[ $taito_env == "dev" ]] || [[ $taito_env == "f-"* ]]; then
  ci_exec_test=false        # enable this to execute test suites
  ci_exec_test_init=false   # run 'init --clean' before each test suite
  if [[ $taito_command == "util-test" ]]; then
    ci_test_base_url=https://$(taito -q secret show:$taito_env basic-auth | head -1)@$taito_domain
  fi
fi

# URLs
test_www_CYPRESS_baseUrl=$ci_test_base_url
if [[ "$taito_target_env" == "local" ]]; then
  CYPRESS_baseUrl=$taito_app_url
else
  CYPRESS_baseUrl=$ci_test_base_url
fi
