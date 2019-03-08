# Development

This file has been copied from [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/dev/DEVELOPMENT.md) instead. Project specific conventions are located in [README.md](README.md#conventions). See the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for more thorough development instructions. Note that Taito CLI is optional (see [without Taito CLI](#without-taito-cli)).

Table of contents:

* [Prerequisites](#prerequisites)
* [Quick start](#quick-start)
* [Automated tests](#automated-tests)
* [Code structure](#code-structure)
* [Version control](#version-control)
* [Deployment](#deployment)
* [Configuration](#configuration)
* [Without Taito CLI](#without-taito-cli)

## Prerequisites

* [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* Optional: [Taito CLI](https://github.com/TaitoUnited/taito-cli#readme)
* Optional: eslint and prettier plugins for your code editor

## Quick start

Install linters and some libraries on host for code autocompletion purposes (add `--clean` to make a clean reinstall):

    taito install

Start containers (add `--clean` to make a clean rebuild, and to discard all data and db tables):

    taito start

Make sure that everything has been initialized (e.g database) (add `--clean` to make a clean reinit):

    taito init

Open site in browser:

    taito open www

Show user accounts and other information that you can use to log in:

    taito info

Run tests:

    taito unit                              # run all unit tests
    taito unit:www post                     # run the 'post' unit test of www
    taito test                              # run all end-to-end tests

Open Cypress user interface:

    taito cypress                           # open cypress

> TIP: Testing personnel may run Cypress against any remote environment without Taito CLI or docker. See `www/test/README.md` for more instructions.

Start shell on a container:

    taito shell:www

Stop containers:

    taito stop

List all project related links and open one of them in browser:

    taito open -h
    taito open NAME

Check bundle size and dependencies:

    taito check deps
    taito check deps:www
    taito check deps:www -u                 # update packages interactively
    taito check deps:www -y                 # update all packages (non-iteractive)

> NOTE: Many of the `devDependencies` and `~` references are actually in use even if reported unused. But all unused `dependencies` can usually be removed from package.json.

Cleaning:

    taito clean:www                         # Remove www container image
    taito clean:npm                         # Delete node_modules directories
    taito clean                             # Clean everything

The commands mentioned above work also for server environments (`f-NAME`, `dev`, `test`, `stag`, `canary`, `prod`). Some examples for dev environment:

    taito --auth:dev                        # Authenticate to dev
    taito open www:dev                      # Open site in browser
    taito info:dev                          # Show info
    taito status:dev                        # Show status of dev environment
    taito open builds                       # Show build status and logs
    taito test:dev                          # Run integration and e2e tests
    taito cypress:www:dev                   # Open cypress for www
    taito shell:www:dev                     # Start a shell on www container
    taito logs:www:dev                      # Tail logs of www container
    taito open logs:dev                     # Open logs on browser
    taito secrets:dev                       # Show secrets (e.g. database user credentials)

Run `taito -h` to get detailed instructions for all commands. Run `taito COMMAND -h` to show command help (e.g `taito vc -h`, `taito db -h`, `taito db import -h`). For troubleshooting run `taito --trouble`. See [README.md](README.md) for project specific conventions and documentation.

> If you run into authorization errors, authenticate with the `taito --auth:ENV` command.

> It's common that idle applications are run down to save resources on non-production environments. If your application seems to be down, you can start it by running `taito start:ENV`, or by pushing some changes to git.

## Automated tests

Once you have implemented your first integration or e2e test, enable the CI test execution by setting `ci_exec_test=true` at least for dev environment.

## Code structure

Project specific conventions are defined in [README.md](README.md#conventions).

## Version control

Development is done in `dev` and `feature/*` branches. Hotfixes are done in `hotfix/*` branches. You should not commit changes to any other branch.

All commit messages must be structured according to the [Angular git commit convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines) (see also [Conventional Commits](http://conventionalcommits.org/)). This is because application version number and release notes are generated automatically for production release by the [semantic-release](https://github.com/semantic-release/semantic-release) library.

> You can also use `wip` type for such feature branch commits that will be squashed during rebase.

You can manage environment and feature branches using Taito CLI commands. Run `taito vc -h` for instructions. If you use git commands or git GUI tools instead, remember to follow the version control conventions defined by `taito vc conventions`. See [version control](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/03-version-control.md) chapter of the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for some additional information.

## Deployment

Container images are built for dev and feature branches only. Once built and tested successfully, the container images will be deployed to other environments on git branch merge:

* **f-NAME**: Push to the `feature/NAME` branch.
* **dev**: Push to the `dev` branch.
* **test**: Merge changes to the `test` branch using fast-forward.
* **stag**: Merge changes to the `stag` branch using fast-forward.
* **canary**: Merge changes to the `canary` branch using fast-forward. NOTE: Canary environment uses production resources (database, storage, 3rd party services) so be careful with database migrations.
* **prod**: Merge changes to the `master` branch using fast-forward. Version number and release notes are generated automatically by the CI/CD tool.

Simple projects require only two environments: **dev** and **prod**. You can list the environments with `taito vc env list`.

You can use the `taito vc` commands to manage branches, and the `taito deployment` commands to manage builds and deployments. Run `taito vc -h` and `taito deployment -h` for instructions. Run `taito open builds` to see the build logs. See [version control](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/03-version-control.md) chapter of the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for some additional information.

> Automatic deployment might be turned off for critical environments (`ci_exec_deploy` setting in `taito-config.sh`). In such case the deployment must be run manually with the `taito -a deployment deploy:prod VERSION` command using a personal admin account after the CI/CD process has ended successfully.

## Configuration

### Version control settings

Run `taito open vc conventions` in the project directory to see organization specific settings that you should configure for your git repository.

### Static site generator

Gatsby is enabled by default. If you use some other static site generator than Gatsby, copy the corresponding files from `www/alternatives/GENERATOR/` to `www/`.

Create a new site to directory `www/site` according to the static site generator instructions. Example for Gatsby:

    cd www                                       # Move to www directory
    rm -rf site                                  # Remove the example site
    npx gatsby new site STARTER-OF-MY-CHOICE     # Create a new site based on a starter: https://www.gatsbyjs.org/starters?v=2
    rm -rf site/.git                             # Remove the obsolete .git directory
    EDIT site/package.json                       # Expose Gatsby development port outside the Docker container by
                                                 # adding options `--host 0.0.0.0 --port 8080` to the develop script.

### Hosting

By default the template deploys the site to Kubernetes running on Google Cloud.

TODO other options.

### Basic project settings

1. Modify `taito-config.sh` if you need to change some settings. The default settings are ok for most projects.
2. Run `taito project apply`
3. Commit and push changes

### Remote environments

Define remote environments with the `taito_environments` setting in `taito-config.sh`. Make sure that your authentication is in effect for an environment with `taito --auth:ENV`, and then create an environment by running `taito env apply:ENV`. Examples for environment names: `f-orders`, `dev`, `test`, `stag`, `canary`, `prod`. Create a `dev` environment first, and the other environments later if required.

If basic auth (htpasswd) is used only for hiding non-production environments, you can use the same credentials for all environments. In such case you should also write them down to the [links](README.md#links) section on README.md so that all project personnel can easily access the credentials.

> If you have some trouble creating an environment, you can destroy it by running `taito env destroy:ENV` and then try again with `taito env apply:ENV`.

> See [6. Remote environments](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/05-remote-environments.md) chapter of Taito CLI tutorial for more thorough instructions.

> Operations on production and staging environments usually require admin rights. Please contact DevOps personnel if necessary.

### Real-time preview on a remote environment

To enable real-time preview on dev environment:

1. Uncomment lines on `helm-dev.yaml`
2. Make sure that urlprefix and personal git token have been set for webhook by running `taito secrets:dev`. If they are unset, set them with `taito env rotate:dev webhook`
3. Configure a git webhook for your git repository that calls url https://USER:PASSWORD@DEV-DOMAIN/webhook/URLPREFIX/build when changes are pushed to the git repository. For more information see the [GitHub Webhooks Guide](https://developer.github.com/webhooks/).

### Kubernetes

The `scripts/heml.yaml` file contains default Kubernetes settings for all environments and the `scripts/helm-*.yaml` files contain environment specific overrides for them. By modying these files you can easily configure environment variables, resource requirements and autoscaling for your containers.

You can deploy configuration changes without rebuilding with the `taito deployment deploy:ENV` command.

> Do not modify the helm template located in `./scripts/helm` directory. Improve the original helm template located in [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/) repository instead.

### Upgrading to the latest version of the project template

Run `taito project upgrade`. The command copies the latest versions of reusable Helm charts, terraform templates and CI/CD scripts to your project folder, and also this README.md file. You should not make project specific modifications to them as they are designed to be reusable and easily configurable for various needs. Improve the originals instead, and then upgrade.

### Without Taito CLI

You can use this template also without Taito CLI.

**Local development:**

    npm install              # Install a minimal set of libraries on host
    npm run install-dev      # Install more libraries on host (for editor autocompletion/linting)
    docker-compose up        # Start the application
    -> http://localhost:9999 # Open the site on browser (the port is defined in docker-compose.yaml)

    npm run ...              # Use npm to run npm scripts ('npm run' shows all the scripts)
    docker-compose ...       # Use docker-compose to operate your application
    docker ...               # Use docker to operate your containers

**Testing:**

Testing personnel may run Cypress against any remote environment without Taito CLI or docker. See `www/test/README.md` for more instructions.

**Environments and CI/CD:**

Taito CLI supports various infrastructures and technologies out-of-the-box, and you can also extend it by writing custom plugins. If you for some reason want to setup the application environments or run CI/CD steps without Taito CLI, you can write the scripts yourself by using the environment variable values defined in `taito-config.sh`.

Creating an environment:

* Set Kubernetes secret values with `kubectl`. The secrets are defined by `taito_secrets` in `taito-config.sh`, and they are referenced in `scripts/helm*.yaml` files.

Deploying the application:

* Build all container images with [Docker](https://www.docker.com/) and push them to a Docker image registry.
* Deploy application to Kubernetes with [Helm](https://helm.sh/). Helm templates are located in `scripts/helm/` and environment specific values are located in `scripts/helm*.yaml`. Note that Helm does not support environment variables in value yaml files (this feature is implemented in the Taito CLI Helm plugin). Therefore you need to create a separate `scripts/heml-ENV.yaml` file for each environment and use hardcoded values in each.
* Optional: Run automatic tests
* Optional: Revert deployment if some of the tests fail.
* Optional: Make a production release with semantic-release (see `package.json`)
