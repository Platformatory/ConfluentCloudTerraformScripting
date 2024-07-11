variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "admin_kafka_api_key" {
  description = "Cluster Admin Kafka Api Key"
  type        = string
}

variable "admin_kafka_api_secret" {
  description = "Cluster Admin Kafka Api Secret"
  type        = string
  sensitive   = true
}

variable "environment_id" {
  description = "Confluent Environment ID"
  type = string
}

variable "kafka_cluster_id" {
  description = "Kafka cluster ID"
  type = string
}

variable "topics" {
  type = list(object({
    name = string
    partitions = number
    configs = list(object({key = string, value = string}))
  }))
}