resource "confluent_api_key" "app-manager-kafka-api-key" {
  count = var.number_of_api_keys

  display_name = "${var.sa_name}-api-key-${count.index}"
  description  = "Kafka API Key-${count.index} that is owned by ${var.sa_name} service account"
  owner {
    id          = var.sa_id
    api_version = var.sa_api_version
    kind        = var.sa_kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.dedicated.id
    api_version = data.confluent_kafka_cluster.dedicated.api_version
    kind        = data.confluent_kafka_cluster.dedicated.kind

    environment {
      id = data.confluent_environment.default.id
    }
  }
}

### ResourceOwner privileges to various resources

## Topics
resource "confluent_role_binding" "app-manager-owns-topic" {
  for_each = toset(var.topic_names_as_owner)

  principal   = "User:${var.sa_id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${data.confluent_kafka_cluster.dedicated.id}/topic=${each.key}"
}

## Consumer Groups
resource "confluent_role_binding" "app-manager-owns-group" {
  for_each = toset(var.group_names_as_owner)

  principal   = "User:${var.sa_id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${data.confluent_kafka_cluster.dedicated.id}/group=${each.key}"
}

## Transactional IDs
resource "confluent_role_binding" "app-manager-owns-transaction_id" {
  for_each = toset(var.transaction_ids_as_owner)

  principal   = "User:${var.sa_id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${data.confluent_kafka_cluster.dedicated.id}/transactional-id=${each.key}"
}

## Connectors
resource "confluent_role_binding" "app-manager-owns-connector" {
  for_each = toset(var.connector_names_as_owner)

  principal   = "User:${var.sa_id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/connector=${each.key}"
}

## Schema subjects
resource "confluent_role_binding" "app-manager-owns-schema" {
  for_each = toset(var.schema_subjects_as_owner)

  principal   = "User:${var.sa_id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${one(data.confluent_schema_registry_cluster.default[*].resource_name)}/subject=${each.key}"
}

### DeveloperWrite privileges to various resources

## Topics
resource "confluent_role_binding" "app-manager-write-to-topic" {
  for_each = toset(var.topic_names_to_write)

  principal   = "User:${var.sa_id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${data.confluent_kafka_cluster.dedicated.id}/topic=${each.key}"
}

## Transactional IDs
resource "confluent_role_binding" "app-manager-write-to-transaction_id" {
  for_each = toset(var.transaction_ids_to_write)

  principal   = "User:${var.sa_id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${data.confluent_kafka_cluster.dedicated.id}/transactional-id=${each.key}"
}

### DeveloperRead privileges to various resources

## Topics
resource "confluent_role_binding" "app-manager-read-from-topic" {
  for_each = toset(var.topic_names_to_read)

  principal = "User:${var.sa_id}"
  role_name = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${data.confluent_kafka_cluster.dedicated.id}/topic=${each.key}"
}

## Consumer groups
resource "confluent_role_binding" "app-manager-read-from-group" {
  for_each = toset(var.group_names_to_read)

  principal = "User:${var.sa_id}"
  role_name = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${data.confluent_kafka_cluster.dedicated.id}/group=${each.key}"
}

## Schema subjects
resource "confluent_role_binding" "app-manager-read-from-schema" {
  for_each = toset(var.schema_subjects_to_read)

  principal = "User:${var.sa_id}"
  role_name = "DeveloperRead"
  crn_pattern = "${one(data.confluent_schema_registry_cluster.default[*].resource_name)}/subject=${each.key}"
}