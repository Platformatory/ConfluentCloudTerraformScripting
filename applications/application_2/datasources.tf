data "confluent_service_account" "app-manager-sa" {
  display_name = "${var.service_account.name}"
}
