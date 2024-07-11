variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "service_account" {
  type = object({
    name = string
    clusters = list(object({
      environment_id = string
      schema_registry_cluster_id = string
      kafka_cluster_id = string
      number_of_api_keys = optional(number, 1)
      owner = object({
        topics = optional(list(string), [])
        groups = optional(list(string), [])
        transaction_ids = optional(list(string), [])
        connectors = optional(list(string), [])
        schemas = optional(list(string), [])
      })
      write = object({
        topics = optional(list(string), [])
        transaction_ids = optional(list(string), [])
      })
      read = object({
        topics = optional(list(string), [])
        groups = optional(list(string), [])
        schemas = optional(list(string), [])
      })
    }))
  })
}