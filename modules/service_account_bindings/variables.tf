variable "environment_id" {
  description = "The ID of the confluent environment"
  type = string
}

variable "kafka_cluster_id" {
  description = "The ID of the confluent kafka cluster"
  type = string
}

variable "schema_registry_cluster_id" {
  description = "The ID of the schema registry cluster in the environment"
  type = string
}

variable "sa_id" {
  description = "Application Service account ID"
  type = string
}

variable "sa_name" {
  description = "Application Service account name"
  type = string
}

variable "sa_kind" {
  description = "Application Service account resource kind"
  type = string
}

variable "sa_api_version" {
  description = "Application Service account resource api version"
  type = string
}

variable "number_of_api_keys" {
  description = "Number of different API Keys required per Service Account"
  type = number
}

variable "topic_names_as_owner" {
  description = "Prefixed/Literal topics names owned by the application Eg. test*, literal-topic etc."
  type = list(string)
}

variable "group_names_as_owner" {
  description = "Prefixed/Literal group names owned by the application Eg. sample*, literal-group etc."
  type = list(string)
}

variable "transaction_ids_as_owner" {
  description = "Prefixed/Literal transactional ids owned by the application Eg. transact*, transactionId1 etc."
  type = list(string)
}

variable "connector_names_as_owner" {
  description = "Prefixed/Literal connector names owned by the application Eg. mysql*, rds-postgres-1 etc."
  type = list(string)
}

variable "schema_subjects_as_owner" {
  description = "Prefixed/Literal schema subjects owned by the application Eg. test*, sample-topic-value etc."
  type = list(string)
}

variable "topic_names_to_write" {
  description = "Prefixed/Literal topics names written to by the application Eg. test*, literal-topic etc."
  type = list(string)
}

variable "transaction_ids_to_write" {
  description = "Prefixed/Literal transactional ids written to by the application Eg. transact*, transactionId1 etc."
  type = list(string)
}

variable "topic_names_to_read" {
  description = "Prefixed/Literal topics names read by the application Eg. test*, literal-topic etc."
  type = list(string)
}

variable "group_names_to_read" {
  description = "Prefixed/Literal group names read by the application Eg. sample*, literal-group etc."
  type = list(string)
}

variable "schema_subjects_to_read" {
  description = "Prefixed/Literal schema subjects read by the application Eg. test*, sample-topic-value etc."
  type = list(string)
}