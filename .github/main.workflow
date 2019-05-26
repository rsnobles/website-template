# NOTE: This is a quick example that has not yet been tested at all.
# Here we run the same CI/CD steps that are defined also in
# bitbucket-pipelines.yml, cloudbuild.yaml, and build.sh.

workflow "Build, deploy, test, publish" {
  on = "push"
  resolves = ["build-release"]
}

# Prepare build

action "build-prepare" {
  uses = "docker://$template_default_taito_image"
  runs = ["bash", "-c", "taito build prepare:${GITHUB_REF#refs/heads/}"]
  env = {
    taito_mode = "ci"
  }
}

# Prepare artifacts in parallel

action "artifact-prepare:www" {
  needs = "build-prepare"
  uses = "docker://$template_default_taito_image"
  runs = [
    "bash", "-c",
    "taito artifact prepare:www:${GITHUB_REF#refs/heads/} $GITHUB_SHA"
  ]
  env = {
    taito_mode = "ci"
  }
}
action "artifact-prepare:webhook" {
  needs = "build-prepare"
  uses = "docker://$template_default_taito_image"
  runs = [
    "bash", "-c",
    "taito artifact prepare:webhook:${GITHUB_REF#refs/heads/} $GITHUB_SHA"
  ]
  env = {
    taito_mode = "ci"
  }
}

# Deploy

action "deployment-deploy" {
  uses = "docker://$template_default_taito_image"
  runs = ["bash", "-c", "taito deployment deploy:${GITHUB_REF#refs/heads/} $GITHUB_SHA"]
  env = {
    taito_mode = "ci"
  }
}

# Test and verify deployment

action "deployment-wait" {
  uses = "docker://$template_default_taito_image"
  runs = ["bash", "-c", "taito deployment wait:${GITHUB_REF#refs/heads/}"]
  env = {
    taito_mode = "ci"
  }
}
action "test" {
  uses = "docker://$template_default_taito_image"
  runs = ["bash", "-c", "taito test:${GITHUB_REF#refs/heads/}"]
  env = {
    taito_mode = "ci"
  }
}
action "deployment-verify" {
  uses = "docker://$template_default_taito_image"
  runs = ["bash", "-c", "taito deployment verify:${GITHUB_REF#refs/heads/}"]
  env = {
    taito_mode = "ci"
  }
}

# Release artifacts

action "artifact-release:www" {
  needs = "deployment-verify"
  uses = "docker://$template_default_taito_image"
  runs = [
    "bash", "-c",
    "taito artifact release:www:${GITHUB_REF#refs/heads/} $GITHUB_SHA"
  ]
  env = {
    taito_mode = "ci"
  }
}
action "artifact-release:webhook" {
  needs = "deployment-verify"
  uses = "docker://$template_default_taito_image"
  runs = [
    "bash", "-c",
    "taito artifact release:webhook:${GITHUB_REF#refs/heads/} $GITHUB_SHA"
  ]
  env = {
    taito_mode = "ci"
  }
}

# Release build

action "build-release" {
  uses = "docker://$template_default_taito_image"
  runs = [
    "bash", "-c",
    "taito build release:${GITHUB_REF#refs/heads/}"
  ]
  env = {
    taito_mode = "ci"
  }
}
