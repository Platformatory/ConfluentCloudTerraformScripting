variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "cluster_details" {
  description = "Dedicated cluster details adhering to specific format"
  type = object({
    environment_id = string
    network_id = string
    kafka_cluster_name = string
    kafka_cluster_availability = optional(string, "SINGLE_ZONE")
    number_of_ckus = optional(number, 1)
    deploy_schema_registry = optional(bool, false)
    schema_registry_package = optional(string, "ESSENTIALS")
  })
}