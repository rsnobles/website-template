#!/bin/bash
# shellcheck disable=SC2034

##########################################################################
# Environment settings
##########################################################################

taito_environments="dev prod"

# NOTE: Uncomment this line to disable basic auth from ALL environments.
# Use taito-domain-config.sh to disable basic auth from PROD env only.
# taito_basic_auth_enabled=false

# ------ Links ------

link_urls="
  * www[:ENV]=$taito_app_url Website (:ENV)
  * git=https://$taito_vc_repository_url GitHub repository
  * posts=https://$taito_vc_repository_url/tree/dev/www/site/content/blog Content: posts
  * assets=https://$taito_vc_repository_url/tree/dev/www/site/content/assets Content: assets
  * styleguide=https://TODO UI/UX style guide and designs
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
