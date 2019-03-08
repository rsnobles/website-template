/*
# TODO execute the same steps that are defined in cloudbuild.yaml:

# Set the environment
export taito_mode="ci"
export COMMIT_SHA="NOTE: get from jenkins environment"
export $BRANCH_NAME="NOTE: get from jenkins environment"

# Some preparations
taito ci-prepare:server:$BRANCH_NAME $COMMIT_SHA
taito install:$BRANCH_NAME
taito ci-release-pre:$BRANCH_NAME
taito scan:$BRANCH_NAME

# Build and push container images: admin, bot, client, server, worker
taito ci-build:www:$BRANCH_NAME $COMMIT_SHA
taito ci-push:www:$BRANCH_NAME $COMMIT_SHA

# Deploy changes to server
taito ci-deploy:$BRANCH_NAME $COMMIT_SHA

# Test the new deployment
taito ci-wait:$BRANCH_NAME
taito test:$BRANCH_NAME
taito ci-verify:$BRANCH_NAME

# Publish release notes and version tag
taito ci-release-post:$BRANCH_NAME
*/
