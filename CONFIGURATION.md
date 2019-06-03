# Configuration

This file has been copied from [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/dev/CONFIGURATION.md) instead. Note that Taito CLI is optional (see [TAITOLESS.md](TAITOLESS.md)).

## Prerequisites

* [npm](https://github.com/npm/cli) that usually ships with [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Taito CLI](https://github.com/TaitoUnited/taito-cli#readme) (or see [TAITOLESS.md](TAITOLESS.md))
* Optional: eslint/tslint and prettier plugins for your code editor

## Basic settings

1. Run `taito open conventions` in the project directory to see organization specific settings that you should configure for your git repository. At least you should set `dev` as the default branch to avoid people using master branch for development by accident.
2. Modify `taito-config.sh` if you need to change some settings. The default settings are ok for most projects.
3. Run `taito project apply`
4. Commit and push changes

* [ ] All done

## Static site generator and local development environment

Configure static site generator of your choice with the following instructions. Currently instructions are provided only for Gatsby, Hugo, Jekyll and plain static files, but with some extra work the website-template may easily be used with any static site generator.

Remove static site generators that you do not use from `www/install.sh`.

    EDIT www/install.sh

Start containers, and start a shell inside the www Docker container:

    taito kaboom
    taito shell:www

*FOR PLAIN STATIC FILES ONLY:* Exit the shell and add static files to www/assets with your code editor.

*FOR GATSBY ONLY:* Create a new Gatsby site based on one of the [starters](https://www.gatsbyjs.org/starters?v=2) (NOTE: Select 'npm' as package manager and ignore the 'git commit' error):

    su node
    npx gatsby new site STARTER-SOURCE-URL-OF-MY-CHOICE
    rm -rf site/.git
    exit
    exit

*FOR GATSBY ONLY:* Enable `/service/site/node_modules` mount in `docker-compose.yaml`:

    EDIT docker-compose.yaml

*FOR HUGO ONLY:* Create a new Hugo site (See [Hugo themes](https://themes.gohugo.io/) and [Hugo quick start](https://gohugo.io/getting-started/quick-start/) for more details):

    hugo new site site
    cd site
    git clone https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
    rm -rf themes/ananke/.git
    echo 'theme = "ananke"' >> config.toml
    hugo new posts/my-first-post.md
    exit

*FOR HUGO ONLY:* If you have some trouble with links, you might also need to enable relative urls by using the following settings in `www/site/config.toml`:

    baseURL = ""
    relativeURLs = true

*FOR JEKYLL ONLY:* Create a new site:

    bash
    jekyll new site
    exit
    exit

*FOR ALL:* Restart containers and open the site on browser:

    taito stop
    taito start --clean
    taito open www

* [ ] All done

## Your first remote environment (dev)

Make sure your authentication is in effect:

    taito auth:dev

Create the environment (NOTE: You can enter anything as github token, if you don't need live preview):

    taito env apply:dev

Write down the basic auth credentials to [README.md#links](README.md#links):

    EDIT README.md         # Edit the links section

Write down the basic auth credentials to `taito-config.sh`:

    EDIT taito-config.sh   # Edit this: ci_test_base_url=https://username:secretpassword@...

Push some changes to dev branch with a [Conventional Commits](http://conventionalcommits.org/) commit message `chore: configuration`:

    taito stage            # Or just 'git add .'
    taito commit           # Or just 'git commit'
    taito push             # Or just 'git push'

See it build and deploy:

    taito open builds:dev
    taito status:dev
    taito open client:dev

> If you have some trouble creating an environment, you can destroy it by running `taito env destroy:dev` and then try again with `taito env apply:dev`.

* [ ] All done

---

## Remote real-time preview

You can edit the site on GitHub web GUI and preview changes on a remote environment. This is how you enable preview for dev environment:

1. Enable build webhook by editing `scripts/helm-dev.yaml`.
2. Optional: If you want to be able to merge changes between environments using GitHub web GUI, enable builds for all branches by changing `ci_exec_build=false` to `ci_exec_build=true` in `taito-config.sh`. This is required because GitHub web GUI does not support merging with fast-forward.
3. Make sure that urlprefix and personal git token have been set for webhook by running `taito secrets:dev`. If they are unset, set them with `taito env rotate:dev webhook`
4. Configure a git webhook for your git repository. It should call url https://USER:PASSWORD@DEV-DOMAIN/webhook/URLPREFIX/build when changes are pushed to the git repository. For more information see the [GitHub Webhooks Guide](https://developer.github.com/webhooks/).

You can enable the build webhook also for staging, if you like.

## Remote environments

You create the other environments just like you did the dev environment. However, you don't need to write down the basic auth credentials anymore, since you can reuse the same credentials as in dev environment.

Examples for environment names: `f-orders`, `dev`, `test`, `stag`, `canary`, `prod`. You configure project environments with `taito_environments` setting in `taito-config.sh`.

See [6. Remote environments](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/05-remote-environments.md) chapter of Taito CLI tutorial for more thorough instructions.

Operations on production and staging environments usually require admin rights. Please contact DevOps personnel if necessary.

## Custom provider

If you cannot use Docker containers on your remote environments, you can customize the deployment with a custom provider. Instead of deploying the site as docker container image, you can, for example, deploy the site as static files on a web server, or as a WAR package on a Java application server. You can enable the custom provider with the `taito_provider` setting in `taito-config.sh` and implement [custom deployment scripts](https://github.com/TaitoUnited/SERVER-TEMPLATE/blob/master/scripts/custom-provider) yourself.

## Kubernetes

If you need to, you can configure Kubernetes settings by modifying `heml*.yaml` files located under the `scripts`-directory. The default settings, however, are ok for most sites.

## Secrets

You can add a new secret like this:

1. Add a secret definition to the `taito_secrets` or the `taito_remote_secrets` setting in `taito-config.sh`.
2. Map the secret definition to a secret in `docker-compose.yaml` for Docker Compose and in `scripts/helm.yaml` for Kubernetes.
3. Run `taito env rotate:ENV SECRET` to generate a secret value for an environment. Run the command for each environment separately. Note that the rotate command restarts all pods in the same namespace.
