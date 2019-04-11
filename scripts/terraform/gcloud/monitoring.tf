resource "google_monitoring_uptime_check_config" "https" {
  count = "${length(var.taito_monitoring_names)}"

  project = "${var.taito_zone}"
  display_name = "${var.taito_project}-${var.taito_env}-${element(var.taito_monitoring_names, count.index)}"
  timeout = "${element(var.taito_monitoring_timeouts, count.index)}"

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = "${var.taito_domain}"
    }
  }

  http_check {
    use_ssl = true
    port = 443
    path = "${element(var.taito_monitoring_paths, count.index)}"
  }
}

resource "google_monitoring_alert_policy" "https" {
  depends_on = ["google_monitoring_uptime_check_config.https"]
  count = "${length(var.taito_monitoring_names) > 0 ? 1 : 0}"
  enabled = "true"

  project = "${var.taito_zone}"
  display_name = "${var.taito_project}-${var.taito_env}"
  notification_channels = "${var.taito_monitoring_uptime_channels}"

  combiner = "OR"
  conditions = [
    /* TODO: generate conditions dynamically with terraform for-each */
    {/*www*/
      display_name = "${var.taito_project}-${var.taito_env}-www"
      condition_threshold {
        aggregations {
          alignment_period = "1200s"
          cross_series_reducer = "REDUCE_COUNT_FALSE"
          group_by_fields = [
            "resource.*"
          ]
          per_series_aligner = "ALIGN_NEXT_OLDER"
        }
        comparison = "COMPARISON_GT"
        duration = "60s"
        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${var.taito_project}-${var.taito_env}-www\""
        threshold_value = "1.0"
        trigger = {
          count = 1
        }
      }
    }
  ]
}
