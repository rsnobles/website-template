/*
# TODO execute the same steps that are defined in cloudbuild.yaml:

# Set the environment
export taito_mode="ci"
export COMMIT_SHA="NOTE: get from jenkins environment"
export $BRANCH_NAME="NOTE: get from jenkins environment"

# Some preparations
taito install:$BRANCH_NAME
taito build-prepare:$BRANCH_NAME $COMMIT_SHA
taito scan:$BRANCH_NAME

# Build and push container images: admin, bot, client, server, worker
taito artifact-build:www:$BRANCH_NAME $COMMIT_SHA
taito artifact-push:www:$BRANCH_NAME $COMMIT_SHA

# Deploy changes to server
taito deployment-deploy:$BRANCH_NAME $COMMIT_SHA

# Test the new deployment
taito deployment-wait:$BRANCH_NAME
taito test:$BRANCH_NAME
taito deployment-verify:$BRANCH_NAME

# Publish release notes and version tag
taito build-release:$BRANCH_NAME
*/
