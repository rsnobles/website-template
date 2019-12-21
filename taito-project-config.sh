#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154

##########################################################################
# Project specific settings
##########################################################################

# Environments: In the correct order (e.g. dev test uat stag canary prod)
taito_environments="${template_default_environments}"

# Basic auth: Uncomment the line below to disable basic auth from ALL
# environments. Use taito-env-prod-config.sh to disable basic auth from prod
# environment only.
# taito_basic_auth_enabled=false

# Service account: Uncomment the line below to always create Cloud provider
# service account
# provider_service_account_enabled=true

# ------ Stack ------

# Stack
taito_targets="webhook www"
taito_networks="default"

# Stack uptime monitoring
taito_uptime_targets="www"
taito_uptime_paths="/"
taito_uptime_timeouts="5"

# ------ Links ------
# Add custom links here. You can regenerate README.md links with
# 'taito project docs'.

link_urls="
  * www[:ENV]=$taito_app_url Website (:ENV)
  * git=https://$taito_vc_repository_url GitHub repository
  * posts=https://$taito_vc_repository_url/tree/dev/www/site/content/blog Content: posts
  * assets=https://$taito_vc_repository_url/tree/dev/www/site/content/assets Content: assets
"

if [[ "$taito_target_env" != "prod" ]]; then
  link_urls="
    ${link_urls}
    * webhook[:ENV]=$taito_webhook_url Build webhook (:ENV)
  "
fi

# ------ Secrets ------
# Configuration instructions:
# https://taitounited.github.io/taito-cli/tutorial/06-env-variables-and-secrets/

taito_remote_secrets="
  $taito_project-$taito_env-basic-auth.auth:htpasswd-plain
"
taito_secrets=""

# Additional build webhook secrets for non-prod environments
if [[ "$taito_target_env" != "prod" ]]; then
  taito_remote_secrets="
    ${taito_remote_secrets}
    $taito_project-$taito_env-webhook.urlprefix:random
    $taito_project-$taito_env-webhook.gittoken:manual
  "
fi
