# Without Taito CLI

This file has been copied from [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/dev/scripts/taito/TAITOLESS.md) instead. Project specific conventions are located in [README.md](../../README.md#conventions).

Table of contents:

* [Prerequisites](#prerequisites)
* [Quick start](#quick-start)
* [Testing](#testing)
* [Configuration](##onfiguration)

## Prerequisites

* [npm](https://github.com/npm/cli) that usually ships with [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* Optional: Some editor plugins depending on technology (e.g. [ESLint](https://eslint.org/docs/user-guide/integrations#editors) and [Prettier](https://prettier.io/docs/en/editors.html) for JavaScript/TypeScript)

## Quick start

Install mandatory libraries on host:

    npm install

Install additional libraries on host for autocompletion/linting on editor (optional):

    # TODO: Support for Windows without bash
    npm run install-dev

Set up environment variables required by `docker-compose.yaml`:

    # On unix-like shell
    . taito-config.sh

    # On Windows shell
    taitoless.bat

Start containers defined in `docker-compose.yaml`:

    docker-compose up

Open the application on browser:

    http://localhost:9999

Use `npm`, `docker-compose` and `docker` normally to run commands and operate containers.

If you would like to use some of the additional commands provided by Taito CLI also without using Taito CLI, first run the command with verbose option (`taito -v`) to see which commands Taito CLI executes under the hood, and then implement them in your `package.json` or `Makefile`.

## Testing

You may run Cypress against any remote environment without Taito CLI or docker. See `www/test/README.md` for more instructions.

## Configuration

Instructions defined in [CONFIGURATION.md](CONFIGURATION.md) apply. You just need to run commands with `npm` or `docker-compose` directly instead of Taito CLI. If you want to setup the application environments or run CI/CD steps without Taito CLI, see the following instructions.

### Creating an environment

* Run taito-config.sh to set the environment variables for the environment in question (dev, test, stag, canary, or prod):
    ```
    export taito_target_env=dev
    . taito-config.sh
    ```
* IF MONITORING IS REQUIRED:: Run terraform scripts that are located at `scripts/terraform/`. Use `scripts/terraform/common/backend.tf` as backend, if you want to store terraform state on git. Note that the terraform scripts assume that a cloud provider project defined by `taito_resource_namespace` and `taito_resource_namespace_id` already exists and Terraform is allowed to create resources for that project.
* IF BASIC AUTH IS REQUIRED: Set Kubernetes secret values with `kubectl`. The secrets are defined by `taito_secrets` in `scripts/taito/project.sh`, and they are referenced in `scripts/helm*.yaml` files.

### Setting up CI/CD

You can easily implement CI/CD steps without Taito CLI. See [continuous integration and delivery](https://taitounited.github.io/taito-cli/docs/06-continuous-integration-and-delivery) chapter of Taito CLI manual for instructions.
