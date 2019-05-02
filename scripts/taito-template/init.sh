#!/bin/bash

: "${taito_organization:?}"
: "${taito_company:?}"
: "${taito_vc_repository:?}"
: "${taito_vc_repository_alt:?}"

: "${template_default_taito_image:?}"
: "${template_default_organization:?}"
: "${template_default_organization_abbr:?}"
: "${template_default_git_organization:?}"
: "${template_default_git_url:?}"
: "${template_default_sentry_organization:?}"
: "${template_default_domain:?}"
: "${template_default_domain_prod:?}"
: "${template_default_zone:?}"
: "${template_default_zone_prod:?}"
: "${template_default_provider:?}"
: "${template_default_provider_org_id:?}"
: "${template_default_provider_org_id_prod:?}"
: "${template_default_provider_region:?}"
: "${template_default_provider_region_prod:?}"
: "${template_default_provider_zone:?}"
: "${template_default_provider_zone_prod:?}"
: "${template_default_monitoring_uptime_channels_prod:-}"
: "${template_default_container_registry:?}"
: "${template_default_source_git:?}"
: "${template_default_dest_git:?}"
: "${template_default_kubernetes:?}"

: "${template_project_path:?}"
: "${mode:?}"

${taito_setv:?}

# Remove MIT license
# TODO leave a reference to the original?
rm LICENSE

# Remove the example site
rm -rf www/site
sed -i '/    - "\/service\/site\/node_modules"/d' docker-compose.yaml

rm -f scripts/terraform/.gitignore

######################
# Choose CI/CD
######################

ci=${template_default_ci_provider:-}
while [[ " aws azure bitbucket github gitlab gcloud jenkins shell travis " != *" $ci "* ]]; do
  echo "Select CI/CD: aws, azure, bitbucket, github, gitlab, gcloud, jenkins, shell, or travis"
  read -r ci
done

if [[ ${template_default_ci_deploy_with_spinnaker:-} ]]; then
  ci_deploy_with_spinnaker=$template_default_ci_deploy_with_spinnaker
else
  echo "Use Spinnaker for deployment (y/N)?"
  read -r confirm
  if [[ ${confirm} =~ ^[Yy]$ ]]; then
    ci_deploy_with_spinnaker=true
  fi
fi

#######################
# Replace some strings
#######################

if [[ ! ${taito_random_name} ]] || [[ ${taito_random_name} == "website-template" ]]; then
  taito_random_name="$(taito -q util-random-words: 3)"
fi
echo "Setting random name: ${taito_random_name}"
sed -i "s/^taito_random_name=.*$/taito_random_name=${taito_random_name}/" taito-config.sh

# Replace repository url in package.json
sed -i "s|TaitoUnited/website-template.git|${taito_organization}/${taito_vc_repository}.git|g" package.json

# Add some do not modify notes
echo "Adding do-not-modify notes..."

# Remove template note from README.md
{
sed '/TEMPLATE NOTE START/q' README.md
sed -n -e '/TEMPLATE NOTE END/,$p' README.md
} > temp
truncate --size 0 README.md
cat temp > README.md

# Replace some strings
echo "Replacing project and company names in files. Please wait..."
find . -type f -exec sed -i \
  -e "s/server_template/${taito_vc_repository_alt}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/website-template/${taito_vc_repository}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/companyname/${taito_company}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/WEBSITE-TEMPLATE/website-template/g" 2> /dev/null {} \;

# Generate ports
echo "Generating unique random ports (avoid conflicts with other projects)..."

ingress_port=$(shuf -i 8000-9999 -n 1)
sed -i "s/9999/${ingress_port}/g" DEVELOPMENT.md TAITOLESS.md \
  docker-compose.yaml taito-config.sh ./www/develop.sh ./www/package.json &> /dev/null

echo "Replacing template variables with the given settings..."

# Replace template variables in taito-config.sh with the given settings
sed -i "s/taito_company=.*/taito_company=${taito_company}/g" taito-config.sh
sed -i "s/taito_family=.*/taito_family=${taito_family:-}/g" taito-config.sh
sed -i "s/taito_application=.*/taito_application=${taito_application:-}/g" taito-config.sh
sed -i "s/taito_suffix=.*/taito_suffix=${taito_suffix:-}/g" taito-config.sh
sed -i "s/taito_project=.*/taito_project=${taito_vc_repository}/g" taito-config.sh

echo "Replacing template variables with the user specific settings..."

# Replace template variables in taito-config.sh with user specific settings
sed -i "s/\${template_default_organization:?}/${template_default_organization}/g" taito-config.sh
sed -i "s/\${template_default_organization_abbr:?}/${template_default_organization_abbr}/g" taito-config.sh
sed -i "s/\${template_default_git_organization:?}/${template_default_git_organization}/g" taito-config.sh
sed -i "s/\${template_default_git_url:?}/${template_default_git_url//\//\\/}/g" taito-config.sh
sed -i "s/\${template_default_sentry_organization:?}/${template_default_sentry_organization}/g" taito-config.sh
sed -i "s/\${template_default_domain:?}/${template_default_domain}/g" taito-config.sh
sed -i "s/\${template_default_domain_prod:?}/${template_default_domain_prod}/g" taito-config.sh
sed -i "s/\${template_default_zone:?}/${template_default_zone}/g" taito-config.sh
sed -i "s/\${template_default_zone_prod:?}/${template_default_zone_prod}/g" taito-config.sh
sed -i "s/\${template_default_provider:?}/${template_default_provider}/g" taito-config.sh
sed -i "s/\${template_default_provider_org_id:?}/${template_default_provider_org_id}/g" taito-config.sh
sed -i "s/\${template_default_provider_org_id_prod:?}/${template_default_provider_org_id_prod}/g" taito-config.sh
sed -i "s/\${template_default_provider_region:?}/${template_default_provider_region}/g" taito-config.sh
sed -i "s/\${template_default_provider_zone:?}/${template_default_provider_zone}/g" taito-config.sh
sed -i "s/\${template_default_provider_region_prod:?}/${template_default_provider_region_prod}/g" taito-config.sh
sed -i "s/\${template_default_provider_zone_prod:?}/${template_default_provider_zone_prod}/g" taito-config.sh
sed -i "s/\${template_default_monitoring_uptime_channels_prod:-}/${template_default_monitoring_uptime_channels_prod//\//\\\/}/g" taito-config.sh
sed -i "s/\${template_default_container_registry:?}/${template_default_container_registry}/g" taito-config.sh
sed -i "s/\${template_default_source_git:?}/${template_default_source_git}/g" taito-config.sh
sed -i "s/\${template_default_dest_git:?}/${template_default_dest_git}/g" taito-config.sh

# Kubernetes
sed -i \
  "s/\${template_default_kubernetes:?}/${template_default_kubernetes}/g" taito-config.sh

# Storage
sed -i "s/\${template_default_storage_class:-}/${template_default_storage_class:-}/g" taito-config.sh
sed -i "s/\${template_default_storage_class_prod:-}/${template_default_storage_class_prod:-}/g" taito-config.sh
sed -i "s/\${template_default_storage_location:-}/${template_default_storage_location:-}/g" taito-config.sh
sed -i "s/\${template_default_storage_location_prod:-}/${template_default_storage_location_prod:-}/g" taito-config.sh
sed -i "s/\${template_default_storage_days:-}/${template_default_storage_days:-}/g" taito-config.sh
sed -i "s/\${template_default_storage_days_prod:-}/${template_default_storage_days_prod:-}/g" taito-config.sh

# Backups
sed -i "s/\${template_default_backup_class:-}/${template_default_backup_class:-}/g" taito-config.sh
sed -i "s/\${template_default_backup_class_prod:-}/${template_default_backup_class_prod:-}/g" taito-config.sh
sed -i "s/\${template_default_backup_location:-}/${template_default_backup_location:-}/g" taito-config.sh
sed -i "s/\${template_default_backup_location_prod:-}/${template_default_backup_location_prod:-}/g" taito-config.sh
sed -i "s/\${template_default_backup_days:-}/${template_default_backup_days:-}/g" taito-config.sh
sed -i "s/\${template_default_backup_days_prod:-}/${template_default_backup_days_prod:-}/g" taito-config.sh

echo "Removing template settings from cloudbuild.yaml..."

sed -i "s|\${_TEMPLATE_DEFAULT_TAITO_IMAGE}|${template_default_taito_image}|g" cloudbuild.yaml
sed -i '/_TEMPLATE_DEFAULT_/d' cloudbuild.yaml
sed -i '/template_default_taito_image/d' cloudbuild.yaml
sed -i "s|_IMAGE_REGISTRY: eu.gcr.io/\$PROJECT_ID|_IMAGE_REGISTRY: ${template_default_container_registry}/${template_default_zone}|" cloudbuild.yaml

######################
# Initialize CI/CD
######################

echo "Initializing CI/CD: $ci"
ci_script=

# aws
if [[ $ci == "aws" ]]; then
  ci_script=aws-pipelines.yml
  sed -i "s/ gcloud-ci:-local/aws-ci:-local/" taito-config.sh
  echo "NOTE: AWS CI/CD not yet implemented. Implement it in '${ci_script}'."
  read -r
else
  rm -f aws-pipelines.yml
fi

# azure
if [[ $ci == "azure" ]]; then
  ci_script=azure-pipelines.yml
  sed -i "s/ gcloud-ci:-local/azure-ci:-local/" taito-config.sh
  echo "NOTE: Azure CI/CD not yet implemented. Implement it in '${ci_script}'."
  read -r
else
  rm -f azure-pipelines.yml
fi

# bitbucket
if [[ $ci == "bitbucket" ]]; then
  ci_script=bitbucket-pipelines.yml
  sed -i "s/ gcloud-ci:-local/ bitbucket-ci:-local/" taito-config.sh

  # Links
  sed -i "s|^  \\* builds.*|  * builds=https://bitbucket.org/${template_default_git_organization:?}/${taito_vc_repository}/addon/pipelines/home Build logs|" taito-config.sh
  sed -i "s|^  \\* project=.*|  * project=https://bitbucket.org/${template_default_git_organization:?}/${taito_vc_repository}/addon/trello/trello-board Project management|" taito-config.sh
  # TODO: project documentation
else
  rm -f bitbucket-pipelines.yml
fi

# github
if [[ $ci == "github" ]]; then
  ci_script=.github/main.workflow
  sed -i "s/ gcloud-ci:-local/github-ci:-local/" taito-config.sh
  echo "NOTE: GitHub CI/CD not yet implemented. Implement it in '${ci_script}'."
  read -r
else
  rm -rf .github
fi

# gitlab
if [[ $ci == "gitlab" ]]; then
  ci_script=.gitlab-ci.yml
  sed -i "s/ gcloud-ci:-local/gitlab-ci:-local/" taito-config.sh
  echo "NOTE: GitLab CI/CD not yet implemented. Implement it in '${ci_script}'."
  read -r
else
  rm -rf .gitlab-ci.yml
fi

# gcloud
if [[ $ci == "gcloud" ]]; then
  ci_script=cloudbuild.yaml
  sed -i "s|\${_TEMPLATE_DEFAULT_TAITO_IMAGE}|${template_default_taito_image}|g" cloudbuild.yaml
  sed -i '/_TEMPLATE_DEFAULT_/d' cloudbuild.yaml
  sei -i '/taito project create/d' cloudbuild.yaml
  sed -i '/template_default_taito_image/d' cloudbuild.yaml
  sed -i "s|_IMAGE_REGISTRY: eu.gcr.io/\$PROJECT_ID|_IMAGE_REGISTRY: ${template_default_container_registry}|" cloudbuild.yaml
else
  rm -f cloudbuild.yaml
fi

# jenkins
if [[ $ci == "jenkins" ]]; then
  ci_script=Jenkinsfile
  sed -i "s/ gcloud-ci:-local/jenkins-ci:-local/" taito-config.sh
  echo "NOTE: Jenkins CI/CD not yet implemented. Implement it in '${ci_script}'."
  read -r
else
  rm -f Jenkinsfile
fi

# shell
if [[ $ci == "shell" ]]; then
  ci_script=build.sh
  sed -i "s/ gcloud-ci:-local//" taito-config.sh
else
  rm -f build.sh
fi

# spinnaker
if [[ $ci_deploy_with_spinnaker == "true" ]]; then
  echo "NOTE: Spinnaker CI/CD not yet implemented."
  read -r
fi

# travis
if [[ $ci == "travis" ]]; then
  ci_script=.travis.yml
  sed -i "s/ gcloud-ci:-local/travis-ci:-local/" taito-config.sh
  echo "NOTE: Travis CI/CD not yet implemented. Implement it in '${ci_script}'."
  read -r
else
  rm -f .travis.yml
fi

# common
sed -i "s/\$template_default_taito_image_username/${template_default_taito_image_username:-}/g" "${ci_script}"
sed -i "s/\$template_default_taito_image_password/${template_default_taito_image_password:-}/g" "${ci_script}"
sed -i "s/\$template_default_taito_image_email/${template_default_taito_image_email:-}/g" "${ci_script}"
sed -i "s|\$template_default_taito_image|${template_default_taito_image}|g" "${ci_script}"

##############################
# Initialize semantic-release
##############################

if [[ "${template_default_git_provider}" != "github.com" ]]; then
  echo "Disabling semantic-release for git provider '${template_default_git_provider}'"
  echo "TODO: implement semantic-release support for '${template_default_git_provider}'"
  sed -i "s/release-pre:prod\": \"semantic-release/_release-pre:prod\": \"echo DISABLED semantic-release/g" package.json
  sed -i "s/release-post:prod\": \"semantic-release/_release-post:prod\": \"echo DISABLED semantic-release/g" package.json
  sed -i '/github-buildbot/d' taito-config.sh
fi

######################
# Clean up
######################

echo "Cleaning up"
rm -f temp || :
