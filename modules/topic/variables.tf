variable "environment_id" {
  description = "The ID of the confluent environment"
  type = string
}

variable "kafka_cluster_id" {
  description = "The ID of the confluent kafka cluster"
  type = string
}

variable "kafka_api_key" {
  description = "The Cluster Admin Kafka Api Key"
  type = string
}

variable "kafka_api_secret" {
  description = "The Cluster Admin Kafka Api Secret"
  type = string
}

variable "topic_name" {
  description = "Topic Name"
  type = string
}

variable "partition_count" {
  description = "Topic partitions count"
  type = number
  default = 6
}

variable "topic_configs" {
  description = "Topic configurations"
  type = map(string)
  default = {
    "retention.ms" = "86400000"
    "delete.retention.ms" = "86400000"
  }
}