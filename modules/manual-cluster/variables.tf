variable "environment_id" {
  description = "The ID of the confluent environment"
  type = string
}

variable "network_id" {
  description = "The ID of the Confluent Network for the environment"
  type = string
}

variable "kafka_cluster_id" {
  description = "Kafka cluster id"
  type = string
}

variable "deploy_schema_registry" {
  description = "Whether to deploy schema registry or not"
  type = bool
  default = false
}

variable "schema_registry_package" {
  description = "Package type for the schema registry deployment"
  type = string
  default = "ESSENTIALS"
}
