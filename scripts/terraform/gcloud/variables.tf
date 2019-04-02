variable "taito_project" {}
variable "taito_env" {}
variable "taito_domain" {}
variable "taito_zone" {}
variable "taito_namespace" {}
variable "taito_resource_namespace" {}
variable "taito_resource_namespace_id" {}
variable "taito_provider" {}
variable "taito_organization" {}
variable "taito_organization_abbr" {}
variable "taito_monitoring_names" {
  type = "list"
  default = []
}
variable "taito_monitoring_paths" {
  type = "list"
  default = []
}
variable "taito_monitoring_timeouts" {
  type = "list"
  default = []
}
variable "taito_monitoring_uptime_channels" {
  type = "list"
  default = []
}

variable "gcloud_org_id" {}
variable "gcloud_region" {}
variable "gcloud_zone" {}
