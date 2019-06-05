# Development

This file has been copied from [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/dev/DEVELOPMENT.md) instead. Project specific conventions are located in [README.md](README.md#conventions). See the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for more thorough development instructions. Note that Taito CLI is optional (see [TAITOLESS.md](TAITOLESS.md)).

Table of contents:

* [Prerequisites](#prerequisites)
* [Quick start](#quick-start)
* [Development tips](#development-tips)
* [Automated tests](#automated-tests)
* [Code structure](#code-structure)
* [Version control](#version-control)
* [Deployment](#deployment)
* [Upgrading](#upgrading)

## Prerequisites

* [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Taito CLI](https://github.com/TaitoUnited/taito-cli#readme) (or see [TAITOLESS.md](TAITOLESS.md))
* Optional: Some editor plugins depending on technology (e.g. [ESLint](https://eslint.org/docs/user-guide/integrations#editors) and [Prettier](https://prettier.io/docs/en/editors.html) for JavaScript/TypeScript)

## Quick start

Create local environment by installing some libraries and generating secrets (add `--clean` to recreate clean environment):

    taito env apply

Start containers (add `--clean` to make a clean rebuild, and to discard all data and db tables):

    taito start

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

Restart and stop:

    taito restart:www                       # restart the www container
    taito restart                           # restart all containers
    taito stop                              # stop all containers

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

    taito auth:dev                          # Authenticate to dev
    taito env apply:stag                    # Create the dev environment
    taito push                              # Push changes to current branch (dev)
    taito open builds:dev                   # Show build status and build logs
    taito open www:dev                      # Open site in browser
    taito info:dev                          # Show info
    taito status:dev                        # Show status of dev environment
    taito test:dev                          # Run integration and e2e tests
    taito cypress:www:dev                   # Open cypress for www
    taito shell:www:dev                     # Start a shell on www container
    taito logs:www:dev                      # Tail logs of www container
    taito open logs:dev                     # Open logs on browser
    taito secrets:dev                       # Show secrets (e.g. database user credentials)

Run `taito -h` to get detailed instructions for all commands. Run `taito COMMAND -h` to show command help (e.g `taito db -h`, `taito db import -h`). For troubleshooting run `taito --trouble`. See [README.md](README.md) for project specific conventions and documentation.

> If you run into authorization errors, authenticate with the `taito auth:ENV` command.

> It's common that idle applications are run down to save resources on non-production environments. If your application seems to be down, you can start it by running `taito start:ENV`, or by pushing some changes to git.

## Development tips

### Performance tuning

Docker volume mounts can be slow on non-Linux systems. The template uses *delegated* volume mounts to mitigate this issue on macOS, and *rsync* to mitigate the issue on Windows.

To get maximum performace on non-Linux system, you may also choose to run some services locally, if you have all the necessary dependencies installed on your host system. For example, to run the client locally, you can add the following lines to your `taito-user-config.sh`, Taito CLI will modify docker-compose.yaml and docker-nginx.conf accordingly on `taito start`:

   ```
   docker_compose_local_services="server-template-client:8080"
   ```

Note that in addition to running `taito start`, you also need to start the local client manually with the necessary environment variables set, for example:
   ```
   cd client
   export COMMON_PUBLIC_PORT=9999
   export API_URL=/api
   npm run start
   ```

## Automated tests

Once you have implemented your first integration or e2e test, enable the CI test execution by setting `ci_exec_test=true` at least for dev environment.

## Code structure

Project specific conventions are defined in [README.md](README.md#conventions).

## Version control

Development is done in `dev` and `feature/*` branches. Hotfixes are done in `hotfix/*` branches. You should not commit changes to any other branch.

All commit messages must be structured according to the [Angular git commit convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines) (see also [Conventional Commits](http://conventionalcommits.org/)). This is because application version number and release notes are generated automatically for production release by the [semantic-release](https://github.com/semantic-release/semantic-release) library.

> You can also use `wip` type for such feature branch commits that will be squashed during rebase.

You can manage environment and feature branches using Taito CLI commands. Run `taito env -h`, `taito feat -h`, and `taito hotfix -h` for instructions. If you use git commands or git GUI tools instead, remember to follow the version control conventions defined by `taito conventions`. See [version control](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/03-version-control.md) chapter of the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for some additional information.

## Deployment

Container images are built for dev and feature branches only. Once built and tested successfully, the container images will be deployed to other environments on git branch merge:

* **f-NAME**: Push to the `feature/NAME` branch.
* **dev**: Push to the `dev` branch.
* **test**: Merge changes to the `test` branch using fast-forward.
* **stag**: Merge changes to the `stag` branch using fast-forward.
* **canary**: Merge changes to the `canary` branch using fast-forward. NOTE: Canary environment uses production resources (database, storage, 3rd party services) so be careful with database migrations.
* **prod**: Merge changes to the `master` branch using fast-forward. Version number and release notes are generated automatically by the CI/CD tool.

Simple projects require only two environments: **dev** and **prod**. You can list the environments with `taito env list`.

You can use the taito commands to manage branches, builds, and deployments. Run `taito env -h`, `taito feat -h`, `taito hotfix -h`, and `taito deployment -h` for instructions. Run `taito open builds` to see the build logs. See [version control](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/03-version-control.md) chapter of the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for some additional information.

> Automatic deployment might be turned off for critical environments (`ci_exec_deploy` setting in `taito-config.sh`). In such case the deployment must be run manually with the `taito -a deployment deploy:prod VERSION` command using a personal admin account after the CI/CD process has ended successfully.

## Upgrading

Run `taito project upgrade`. The command copies the latest versions of reusable Helm charts and CI/CD scripts to your project folder, and also this README.md file. You should not make project specific modifications to them as they are designed to be reusable and easily configurable for various needs. Improve the originals instead, and then upgrade.
