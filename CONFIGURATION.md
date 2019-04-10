# Configuration

This file has been copied from [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/dev/CONFIGURATION.md) instead. Note that Taito CLI is optional (see [TAITOLESS.md](TAITOLESS.md)).

Table of contents:

* [Prerequisites](#prerequisites)
* [Version control settings](#version-control-settings)
* [Static site generator](#static-site-generator)
* [Hosting options](#hosting-options)
* [Remote environments](#remote-environments)
* [Remote real-time preview](#remote-real-time-preview)

## Prerequisites

* [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Taito CLI](https://github.com/TaitoUnited/taito-cli#readme) (or see [TAITOLESS.md](TAITOLESS.md))
* Optional: eslint/tslint and prettier plugins for your code editor

## Version control settings

Run `taito open vc conventions` in the project directory to see organization specific settings that you should configure for your git repository.

* [ ] All done

## Static site generator

Configure static site generator of your choice with the following instructions. Currently instructions are provided only for Gatsby, Hugo and Jekyll, but with some extra work the website-template may easily be used with any static site generator.

Remove static site generators that you do not use from `www/install.sh`.

    EDIT www/install.sh

Start containers, and start a shell inside the www Docker container:

    taito install
    taito start
    taito shell:www

*FOR GATSBY ONLY:* Create a new Gatsby site based on one of the [starters](https://www.gatsbyjs.org/starters?v=2):

    npx gatsby new site STARTER-SOURCE-URL-OF-MY-CHOICE
    rm -rf site/.git
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

Restart containers and open the site on browser:

    taito stop
    taito start --clean
    taito open www

* [ ] All done

## Hosting options

By default the template deploys the site to Kubernetes running on Google Cloud. TODO: support for GitHub Pages, Netlify, and S3-compatible object storage.

1. Modify `taito-config.sh` if you need to change some settings. The default settings are ok for most projects.
2. Run `taito project apply`.
3. Commit and push changes.

* [ ] All done

## Remote environments

Define remote environments with the `taito_environments` setting in `taito-config.sh`. Make sure that your authentication is in effect for an environment with `taito auth:ENV`, and then create an environment by running `taito env apply:ENV`. Examples for environment names: `f-orders`, `dev`, `test`, `stag`, `canary`, `prod`. Create a `dev` environment first, and the other environments later if required.

If basic auth (htpasswd) is used only for hiding non-production environments, you can use the same credentials for all environments. In such case you should also write them down to the [links](README.md#links) section on README.md so that all project personnel can easily access the credentials.

> If you have some trouble creating an environment, you can destroy it by running `taito env destroy:ENV` and then try again with `taito env apply:ENV`.

> See [6. Remote environments](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/05-remote-environments.md) chapter of Taito CLI tutorial for more thorough instructions.

> Operations on production and staging environments usually require admin rights. Please contact DevOps personnel if necessary.

* [ ] All done

## Remote real-time preview

You can edit the site on GitHub web GUI and preview changes on a remote environment. This is how you enable preview for dev environment:

1. Enable build webhook by editing `scripts/helm-dev.yaml`.
2. Enable builds for all branches by changing `ci_exec_build=false` to `ci_exec_build=true` in `taito-config.sh`. This is required because GitHub web GUI does not support merging with fast-forward.
3. Make sure that urlprefix and personal git token have been set for webhook by running `taito secrets:dev`. If they are unset, set them with `taito env rotate:dev webhook`
4. Configure a git webhook for your git repository. It should call url https://USER:PASSWORD@DEV-DOMAIN/webhook/URLPREFIX/build when changes are pushed to the git repository. For more information see the [GitHub Webhooks Guide](https://developer.github.com/webhooks/).

You can enable the build webhook also for staging, if you like.

* [ ] All done
