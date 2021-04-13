#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154

##########################################################################
# Project specific labels
#
# Names of namespaces and resources are determined by these labels.
##########################################################################

taito_project=website-template
taito_project_short=wstemplate # Max 10 characters
taito_random_name=website-template
taito_company=companyname
taito_family=
taito_application=template
taito_suffix=

# Namespace
taito_namespace=website-template-$taito_env

# Database defaults
taito_default_db_type=pg
taito_default_db_shared=false # If true, taito_random_name is used as pg db name

# Template
template_version=1.0.0
template_name=WEBSITE-TEMPLATE
template_source_git=git@github.com:TaitoUnited
