#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154

##########################################################################
# Project specific settings
##########################################################################

# Taito CLI: Project specific plugins (for the selected database, etc.)
taito_plugins="
  ${taito_plugins}
"

# Environments: In the correct order (e.g. dev test uat stag canary prod)
taito_environments="${template_default_environments}"

# Basic auth: Uncomment the line below to disable basic auth from ALL
# environments. Use prod-env.sh to disable basic auth from prod
# environment only.
# taito_basic_auth_enabled=false

# ------ Stack ------
# Configuration instructions:
# TODO

if [[ ${taito_deployment_platforms} == *"docker"* ]] ||
   [[ ${taito_deployment_platforms} == *"kubernetes"* ]]; then
  taito_containers="webhook www"
else
  taito_functions=""
fi
taito_static_contents="www"
taito_databases=""
taito_networks="default"

# Buckets
taito_buckets=""

# ------ Secrets ------
# Configuration instructions:
# https://taitounited.github.io/taito-cli/tutorial/06-env-variables-and-secrets/

# Secrets for all environments
taito_secrets="
  ${taito_secrets}
"

# Secrets for local environment only
taito_local_secrets="
"

# Secrets for non-local environments
# TODO: Add webhook secrets only if webhook is enabled
taito_remote_secrets="
  $taito_project-$taito_env-basic-auth.auth:htpasswd-plain
  $taito_project-$taito_env-webhook.urlprefix:random
  $taito_project-$taito_env-webhook.gittoken:manual
  $taito_project-$taito_env-webhook.slackurl:manual
"

# Secrets required by CI/CD
taito_cicd_secrets="
"

# Secrets required by CI/CD tests
taito_testing_secrets="
  $taito_project-$taito_env-basic-auth.auth
"

# Secret hints and descriptions
taito_secret_hints="
  * basic-auth=Basic authentication is used to hide non-production environments from public.
  * webhook.gittoken=Git token used by webhook to pull latest changes from Git. Valid token required only if VC_PULL_ENABLED is true.
  * webhook.slackurl=Slack url used by webhook to send slack messages. Valid url required only if SLACK_CHANNEL has been set.
"

# ------ Links ------
# Add custom links here. You can regenerate README.md links with
# 'taito project generate'. Configuration instructions: TODO

link_urls="
  * cms[:ENV]=https://MY-CMS CMS (:ENV)
  * www[:ENV]=$taito_app_url Website (:ENV)
  * preview[:ENV]=$taito_app_url/preview Website preview (:ENV)
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
