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

* [Links](#links)
* [Editing the website](#links)
* [Contacts](#contacts)
* [Responsibilities](#responsibilities)
* [Miscellaneous notes](#miscellaneous-notes)
* [Conventions](#conventions)

## Links

Basic auth credentials for non-production environments: `USER` / `PASS`.

[//]: # (GENERATED LINKS START)

LINKS WILL BE GENERATED HERE

[//]: # (GENERATED LINKS END)

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Editing the website

You can edit the website directly on GitHub.

> NOTE: These are example instructions provided by the website-template. Modify these so that they apply to your site. If there are multiple people working on the website, and dev branch is being actively developed, it is recommended to configure the project so that new content is created to stag branch instead of dev.

### Create a new blog post

1) Open the [blog folder](www/site/content/blog) on a new tab.
2) Press the **Create new file** button on top of the page.
3) Enter blog name followed with /index.md, for example: `happy-days/index.md`.
4) Enter blog content in [Markdown syntax](https://help.github.com/en/articles/basic-writing-and-formatting-syntax). See the example below. Use the preview tab to preview your changes.
    ```
    ---
    title: Happy Days
    date: "2019-05-01T15:12:03.284Z"
    ---

    Todays was a happy day.

    ![I'm happy](./happy.jpg)
    ```
5) Commit your changes by pressing the **Commit new file** button on bottom of the page.
6) If required, upload images for you blog post by pressing the **Upload files** button on top of the page. Remember to commit your images by pressing the **Commit changes** button on bottom of the page.

### Update a blog post

1) Open the [blog folder](www/site/content/blog) on a new tab.
2) Browse to a file that you would like edit.
3) Enter edit mode by pressing the **Pen** icon.
4) Enter blog content in [Markdown syntax](https://help.github.com/en/articles/basic-writing-and-formatting-syntax). Use the preview tab to preview your changes.
5) Commit your changes by pressing the **Commit changes** button on bottom of the page.
6) If required, upload images for you blog post by pressing the **Upload files** button on top of the page. Remember to commit your images by pressing the **Commit changes** button on bottom of the page.

### Preview and release changes

1) Open the [development site](https://my-project-dev.mydomain.com) on a new tab. If you don't see your changes, open it in incognito mode (on Chrome: click the link with right mouse button and select *Open Link in Incognito Window*).
2) Check that your changes look ok on the development site.
3) Create a new pull request on GitHub:

   * Press the `New pull request button`.
   * Select: `base: master` < `compare:dev` on top of the page.
   * Enter some title for the pull request and press the `Create pull request` button.

4) Merge the pull request by pressing the **Merge pull request** button.
5) The [site](https://my-project.mydomain.com) will be updated automatically after a few minutes.

## Contacts

* Project Manager: John Doe, Company co.
* Designer: Jane Doe, Company co.

> NOTE: It is recommended to use a shared address book or CRM for keeping the contact details like email and phone number up-to-date.

## Responsibilities

Hosting, billing and control of 3rd party services, SSL/TLS certificates, etc.

## Miscellaneous notes

Misc notes.

## Conventions

Project specific conventions.
