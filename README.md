> This page contains a short summary of the project itself. See [DEVELOPMENT.md](DEVELOPMENT.md) for development instructions.

[//]: # (TEMPLATE NOTE START)

# website-template

Implement a website with a static site generator of your choice (e.g. Gatsby, Hugo or Jekyll). Deploy the website to Kubernetes, GitHub Pages (TODO), Netlify (TODO), or any S3-compatible object storage with CDN support (TODO). Setup an automated multistage publishing process for the website. Optionally use the Netlify CMS to edit your site.

You can create a new project from this template by running `taito project create: website-template`. Later you can upgrade your project to the latest version of the template by running `taito project upgrade`. To ensure flawless upgrade, do not modify files that have a **do-not-modify** note in them as they are designed to be reusable and easily configurable for various needs. In such case, improve the original files of the template instead, and then upgrade.

NOTE: This template is a subset of [server-template](https://github.com/TaitoUnited/server-template/). Use the server-template instead, if you need more than just a static website.

[//]: # (TEMPLATE NOTE END)
# Project title

Short description of the website.

Table of contents:

* [Editing the website](#links)
* [Links](#links)
* [Contacts](#contacts)
* [Responsibilities](#responsibilities)
* [Intellectual property rights](#intellectual-property-rights)
* [Recurring issues and solutions](#recurring-issues-and-solutions)
* [Miscellaneous notes](#miscellaneous-notes)
* [Conventions](#conventions)

## Editing the website

You can edit the website directly on GitHub.

> NOTE: These are example instructions provided by the website-template. Modify these so that they apply to your site. If there are multiple people working on the website, and dev branch is being actively developed, it is recommended to configure the project so that new content is created to stag branch instead of dev.

### Create a new blog post

1) Open the <a href="www/site/content/blog" target="_blank">blog folder</a> on a new tab.
2) Press the **Create new file** button on top of the page.
3) Enter blog name followed with /index.md, for example: `happy-days/index.md`.
4) Enter blog content in <a href="https://help.github.com/en/articles/basic-writing-and-formatting-syntax" target="_blank">Markdown syntax</a>. See the example below. Use the preview tab to preview your changes.
    ```
    ---
    title: Happy Days
    date: "2019-05-01T15:12:03.284Z"
    ---

    Todays was a happy day.

    ![I'm happy](./happy.jpg)
    ```
5) Commit your changes by pressing the **Commit new file** button on bottom of the page.
6) If required, upload pictures for you blog post by pressing the `Upload files` button on top of the page.

### Update a blog post

1) Open the <a href="www/site/content/blog" target="_blank">blog folder</a> on a new tab.
2) Browse to a file that you would like edit.
3) Enter edit mode by pressing the **Pen** icon.
4) Enter blog content in <a href="https://help.github.com/en/articles/basic-writing-and-formatting-syntax" target="_blank">Markdown syntax</a>. Use the preview tab to preview your changes.
5) Commit your changes by pressing the **Commit new file** button on bottom of the page.

### Preview and release the changes

1) Open the <a href="https://my-project-dev.mydomain.com" target="_blank">development site</a> on a new tab.
2) Check that everything looks ok.
3) Create a new pull request on GitHub:

   * Press the `New pull request button`.
   * Select: `base: master` < `compare:dev` on top of the page.
   * Enter some title for the pull request and press the `Create pull request` button.

4) TODO: Merge the pull request using fast-forward.
5) The <a href="https://my-project.mydomain.com" target="_blank">site</a> will be updated automatically after a few minutes.

## Links

Non-production basic auth credentials: CREDENTIALS

[//]: # (GENERATED LINKS START)

LINKS WILL BE GENERATED HERE

[//]: # (GENERATED LINKS END)

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Contacts

* Project Manager: John Doe, Company co.
* Designer: Jane Doe, Company co.

> NOTE: It is recommended to use a shared address book or CRM for keeping the contact details like email and phone number up-to-date.

## Responsibilities

Hosting, billing and control of 3rd party services, SSL/TLS certificates, etc.

## Intellectual property rights

> IPR ownership. Also update the LICENSE file. TODO license examples

## Recurring issues and solutions

See trouble.txt or run `taito --trouble`.

## Miscellaneous notes

Misc notes.

## Conventions

Project specific conventions.
