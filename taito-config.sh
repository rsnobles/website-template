#!/bin/bash
# shellcheck disable=SC2034
set -a
: "${taito_target_env:?}"

# Configuration instructions:
# - https://taito.dev/docs/05-configuration
# - https://taito.dev/plugins

# Taito CLI
taito_version=1
taito_plugins="
  terraform:-local
  default-secrets generate-secrets
  docker docker-compose:local kubectl:-local helm:-local
  npm git-global links-global
  sentry semantic-release:prod
"

# Project labeling
taito_organization=${template_default_organization:?}
taito_organization_abbr=${template_default_organization_abbr:?}
taito_project=website-template
taito_random_name=website-template
taito_company=companyname
taito_family=
taito_application=template
taito_suffix=

# Assets
taito_project_icon=$taito_project-dev.${template_default_domain:?}/favicon.ico

# Environments
taito_environments="dev prod"
taito_env=${taito_target_env/canary/prod} # canary -> prod

# Provider and namespaces
taito_provider=${template_default_provider:?}
taito_provider_org_id=${template_default_provider_org_id:?}
taito_provider_region=${template_default_provider_region:?}
taito_provider_zone=${template_default_provider_zone:?}
taito_zone=${template_default_zone:?}
taito_namespace=$taito_project-$taito_env
taito_resource_namespace=$taito_organization_abbr-$taito_company-dev

# URLs
taito_domain=$taito_project-$taito_target_env.${template_default_domain:?}
taito_default_domain=$taito_project-$taito_target_env.${template_default_domain:?}
taito_app_url=https://$taito_domain
taito_static_url=

# Hosts
taito_host="${template_default_host:-}"
taito_host_dir="/projects/$taito_namespace"

# Version control
taito_vc_provider=${template_default_vc_provider:?}
taito_vc_repository=$taito_project
taito_vc_repository_url=${template_default_vc_url:?}/$taito_vc_repository

# CI/CD
taito_ci_provider=${template_default_ci_provider:?}

# Container registry
taito_container_registry_provider=${template_default_container_registry_provider:-}
taito_container_registry=${template_default_container_registry:-}/$taito_vc_repository

# Messaging
taito_messaging_app=slack
taito_messaging_webhook=
taito_messaging_channel=companyname
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring

# Uptime monitoring
taito_uptime_provider=${template_default_uptime_provider:-}
taito_uptime_provider_org_id=${template_default_uptime_provider_org_id:-}
taito_uptime_targets=" www "
taito_uptime_paths=" / "
taito_uptime_timeouts=" 5s "
# You can list all monitoring channels with `taito env info:ENV`
taito_uptime_uptime_channels="${template_default_monitoring_uptime_channels:-}"

# Stack
taito_targets="webhook www"
taito_storages=""
taito_networks="default"

# Stack types ('container' by default)
# -

# Storage definitions for Terraform
taito_storage_classes="${template_default_storage_class:-}"
taito_storage_locations="${template_default_storage_location:-}"
taito_storage_days=${template_default_storage_days:-}

# Storage backup definitions for Terraform
taito_backup_locations="${template_default_backup_location:-}"
taito_backup_days="${template_default_backup_days:-}"

# Misc
taito_basic_auth_enabled=true
taito_default_password=secret1234

# ------ CI/CD default settings ------

# NOTE: Most of these should be enabled for dev and feat branches only.
# That is, container image is built and tested on dev environment first.
# After that the same container image will be deployed to other environments:
# dev -> test -> stag -> canary -> prod
ci_exec_build=false        # build container image if it does not exist already
ci_exec_deploy=${template_default_ci_exec_deploy:-true}        # deploy automatically
ci_exec_test=false         # execute test suites after deploy
ci_exec_test_wait=60       # how many seconds to wait for deployment/restart
ci_exec_test_init=false    # run 'init --clean' before each test suite
ci_exec_revert=false       # revert deployment automatically on fail
ci_static_assets_location= # location to publish all static files (CDN)
ci_test_base_url="http://NOT-CONFIGURED-FOR-$taito_env"

# ------ Plugin and provider specific settings ------

# Template plugin
template_name=WEBSITE-TEMPLATE
template_source_git=git@github.com:TaitoUnited

# Kubernetes plugin
kubernetes_name=${template_default_kubernetes:?}
kubernetes_cluster="${template_default_kubernetes_cluster_prefix:?}${kubernetes_name}"
kubernetes_replicas=1
kubernetes_db_proxy_enabled=true

# Helm plugin
# helm_deploy_options="--atomic --cleanup-on-fail --force"

# Sentry plugin
sentry_organization=${template_default_sentry_organization:?}

# ------ Overrides for different environments ------

case $taito_env in
  prod)
    # Settings
    taito_basic_auth_enabled=true
    kubernetes_replicas=2

    # Provider and namespaces
    taito_zone=${template_default_zone_prod:?}
    taito_provider=${template_default_provider_prod:?}
    taito_provider_org_id=${template_default_provider_org_id_prod:?}
    taito_provider_region=${template_default_provider_region_prod:?}
    taito_provider_zone=${template_default_provider_zone_prod:?}
    taito_resource_namespace=$taito_organization_abbr-$taito_company-prod

    # Domain and resources
    taito_domain=
    taito_domain=$taito_project-$taito_target_env.${template_default_domain_prod:?} # TEMPLATE-REMOVE
    taito_default_domain=$taito_project-$taito_target_env.${template_default_domain_prod:?}
    taito_app_url=https://$taito_domain
    taito_host="${template_default_host_prod:-}"
    kubernetes_cluster="${template_default_kubernetes_cluster_prefix_prod:-}${kubernetes_name}"
    db_database_real_host="${template_default_postgres_host_prod:-}"

    # Storage
    taito_storage_classes="${template_default_storage_class_prod:-}"
    taito_storage_locations="${template_default_storage_location_prod:-}"
    taito_storage_days=${template_default_storage_days_prod:-}
    taito_backup_locations="${template_default_backup_location_prod:-}"
    taito_backup_days="${template_default_backup_days_prod:-}"

    # Monitoring
    taito_uptime_provider=${template_default_uptime_provider_prod:-}
    taito_uptime_provider_org_id=${template_default_uptime_provider_org_id_prod:-}
    taito_uptime_channels="${template_default_monitoring_uptime_channels_prod:-}"

    # CI/CD and repositories
    taito_container_registry_provider=${template_default_container_registry_provider_prod:-}
    taito_container_registry=${template_default_container_registry_prod:-}/$taito_vc_repository
    taito_ci_provider=${template_default_ci_provider_prod:?}
    ci_exec_deploy=${template_default_ci_exec_deploy_prod:-true}
    ;;
  stag)
    # Settings
    taito_basic_auth_enabled=true
    kubernetes_replicas=2

    # Provider and namespaces
    taito_zone=${template_default_zone_prod:?}
    taito_provider=${template_default_provider_prod:?}
    taito_provider_org_id=${template_default_provider_org_id_prod:?}
    taito_provider_region=${template_default_provider_region_prod:?}
    taito_provider_zone=${template_default_provider_zone_prod:?}
    taito_resource_namespace=$taito_organization_abbr-$taito_company-prod

    # Domain and resources
    taito_domain=$taito_project-$taito_target_env.${template_default_domain_prod:?}
    taito_default_domain=$taito_project-$taito_target_env.${template_default_domain_prod:?}
    taito_app_url=https://$taito_domain
    taito_host="${template_default_host_prod:-}"
    kubernetes_cluster="${template_default_kubernetes_cluster_prefix_prod:-}${kubernetes_name}"
    db_database_real_host="${template_default_postgres_host_prod:-}"

    # Monitoring
    taito_uptime_provider=${template_default_uptime_provider_prod:-}
    taito_uptime_provider_org_id=${template_default_uptime_provider_org_id_prod:-}
    taito_uptime_channels="${template_default_monitoring_uptime_channels_prod:-}"

    # CI/CD and repositories
    taito_container_registry_provider=${template_default_container_registry_provider_prod:-}
    taito_container_registry=${template_default_container_registry_prod:-}/$taito_vc_repository
    taito_ci_provider=${template_default_ci_provider_prod:?}
    ci_exec_deploy=${template_default_ci_exec_deploy_prod:-true}
    ;;
  test)
    ci_test_base_url=https://TODO:TODO@$taito_domain
    ;;
  dev|feat)
    ci_exec_build=true        # allow build of a new container
    ci_exec_deploy=true       # deploy automatically
    # NOTE: enable tests once you have implemented some integration or e2e tests
    ci_exec_test=false        # execute test suites
    ci_exec_test_init=false   # run 'init --clean' before each test suite
    ci_exec_revert=false      # revert deploy if previous steps failed
    ci_test_base_url=https://username:secretpassword@$taito_domain
    ;;
  local)
    ci_exec_test_init=false   # run 'init --clean' before each test suite
    ci_test_base_url=http://website-template-ingress:80
    taito_app_url=http://localhost:9999
    ;;
esac

# ------ Derived values after environment specific settings ------

# Provider and namespaces
taito_resource_namespace_id=$taito_resource_namespace
taito_uptime_namespace_id=$taito_zone

# URLs
taito_webhook_url=$taito_app_url/webhook/SECRET/build
if [[ "$taito_target_env" == "local" ]]; then
  taito_webhook_url=http://localhost:9000/SECRET/build
fi

# Link plugin
link_urls="
  * www[:ENV]=$taito_app_url Website (:ENV)
  * git=https://$taito_vc_repository_url GitHub repository
  * posts=https://$taito_vc_repository_url/tree/dev/www/site/content/blog Content: posts
  * assets=https://$taito_vc_repository_url/tree/dev/www/site/content/assets Content: assets
  * styleguide=https://TODO UI/UX style guide and designs
"

# ------ Secrets ------

taito_secrets="
  $taito_project-$taito_env-basic-auth.auth:htpasswd-plain
"

# Additional build webhook secrets for non-prod environments
if [[ "$taito_target_env" != "prod" ]]; then
  link_urls="
    ${link_urls}
    * webhook[:ENV]=$taito_webhook_url Build webhook (:ENV)
  "
  taito_secrets="
    ${taito_secrets}
    $taito_project-$taito_env-webhook.urlprefix:random
    $taito_project-$taito_env-webhook.gittoken:manual
  "
fi

# ------ Taito config override (optional) ------

if [[ $TAITO_CONFIG_OVERRIDE ]] && [[ -f $TAITO_CONFIG_OVERRIDE ]]; then
  # shellcheck disable=SC1090
  . "$TAITO_CONFIG_OVERRIDE"
fi

# ------ Provider specific settings ------
# NOTE: These have been copied from WEBSITE-TEMPLATE and should not be modified.

case $taito_provider in
  aws)
    taito_plugins="
      aws:-local
      ${taito_plugins}
    "

    link_urls="
      ${link_urls}
      * logs:ENV=https://${taito_provider_region}.console.aws.amazon.com/cloudwatch/home?region=${taito_provider_region}#logs: Logs (:ENV)
    "
    ;;
  gcp)
    taito_plugins="
      gcp:-local
      gcp-secrets:-local
      ${taito_plugins}
      gcp-monitoring:-local
    "

    link_urls="
      ${link_urls}
      * logs:ENV=https://console.cloud.google.com/logs/viewer?project=$taito_zone&minLogLevel=0&expandAll=false&resource=container%2Fcluster_name%2F$kubernetes_name%2Fnamespace_id%2F$taito_namespace Logs (:ENV)
    "

    kubernetes_db_proxy_enabled=false # use google cloud sql proxy instead
    gcp_service_account_enabled=true
    ;;
  linux)
    # Enable ssh and run plugins
    taito_plugins="
      ssh:-local
      run:-local
      ${taito_plugins}
    "
    run_scripts_location="scripts/linux-provider"
    # Set some configuration parameters for scripts/linux-provider scripts
    LINUX_SUDO=sudo # NOTE: Put empty value if sudo is not required or allowed
    LINUX_CLIENT_MAX_BODY_SIZE=1m
    # Use Docker Compose instead of Kubernetes and Helm
    taito_plugins="${taito_plugins/docker-compose:local/docker-compose}"
    taito_plugins="${taito_plugins/kubectl:-local/}"
    taito_plugins="${taito_plugins/helm:-local/}"
    # Use SSH plugin as database proxy
    export ssh_db_proxy="\
      -L 0.0.0.0:\${database_port}:\${database_host}:\${database_real_port} \${taito_ssh_user}@\${database_real_host}"
    export ssh_forward_for_db="${ssh_db_proxy}"
    ;;
esac

case $taito_uptime_provider in
  gcp)
    taito_plugins="${taito_plugins/gcp:-local/}"
    taito_plugins="
      gcp:-local
      ${taito_plugins}
    "
    link_urls="
      ${link_urls}
      * uptime=https://app.google.stackdriver.com/uptime?project=$taito_zone&f.search=$taito_project Uptime monitoring (Stackdriver)
    "
    ;;
esac

case $taito_ci_provider in
  bitbucket)
    taito_plugins="
      ${taito_plugins}
      bitbucket-ci:-local
    "
    link_urls="
      ${link_urls}
      * builds=https://$taito_vc_repository_url/addon/pipelines/home Build logs
      * artifacts=https://TODO-DOCS-AND-TEST-REPORTS Generated documentation and test reports
    "
    ;;
  gcp)
    taito_plugins="
      ${taito_plugins}
      gcp-ci:-local
    "
    link_urls="
      ${link_urls}
      * builds[:ENV]=https://console.cloud.google.com/cloud-build/builds?project=$taito_zone&query=source.repo_source.repo_name%3D%22github_${template_default_vc_organization:?}_$taito_vc_repository%22 Build logs
      * artifacts=https://TODO-DOCS-AND-TEST-REPORTS Generated documentation and test reports
    "
    # Google Cloud build does not support storing build secrets on user account
    # or organization level. Therefore we use Kubernetes devops namespace.
    if [[ $taito_plugins == *"semantic-release:$taito_env"* ]]; then
      taito_remote_secrets="
        $taito_remote_secrets
        github-buildbot.token:read/devops
      "
    fi
    ;;
  local)
    link_urls="
      ${link_urls}
      * builds=./local-ci.sh Local CI/CD
    "
    ;;
esac

case $taito_vc_provider in
  bitbucket)
    link_urls="
      ${link_urls}
      * docs=https://$taito_vc_repository_url/wiki/Home Project documentation
      * project=https://$taito_vc_repository_url/addon/trello/trello-board Project management
    "
    ;;
  github)
    link_urls="
      ${link_urls}
      * docs=https://$taito_vc_repository_url/wiki Project documentation
      * project=https://$taito_vc_repository_url/projects Project management
    "
    ;;
esac

case $taito_container_registry_provider in
  aws)
    # Enable AWS auth
    taito_plugins="${taito_plugins/aws:-local/}"
    taito_plugins="
      aws:-local
      ${taito_plugins}
    "
    ;;
  docker)
    # Enable Docker Hub auth
    taito_plugins="
      docker-registry:-local
      ${taito_plugins}
    "
    ;;
  gcp)
    # Enable gcp auth
    taito_plugins="${taito_plugins/gcp:-local/}"
    taito_plugins="
      gcp:-local
      ${taito_plugins}
    "
    ;;
  local)
    ;;
esac

if [[ $taito_plugins == *"sentry"* ]]; then
  sentry_organization=${template_default_sentry_organization:-}
  link_urls="
    ${link_urls}
    * errors:ENV=https://sentry.io/${template_default_sentry_organization:-}/$taito_project/?query=is%3Aunresolved+environment%3A$taito_target_env Sentry errors (:ENV)
  "
fi

# ------ Test suite settings ------
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

set +a
