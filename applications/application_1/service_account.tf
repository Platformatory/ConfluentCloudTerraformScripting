resource "confluent_service_account" "app-manager-sa" {
  display_name = "${var.service_account.name}"
  description  = "Service Account for ${var.service_account.name} app"
}

module "sa_role_bindings" {
    source = "../../modules/service_account_bindings"

    for_each = { for c in var.service_account.clusters : c.kafka_cluster_id => c }

    ## Instance details
    environment_id = each.value.environment_id
    kafka_cluster_id = each.key
    schema_registry_cluster_id = each.value.schema_registry_cluster_id

    ## Service account details
    sa_name = confluent_service_account.app-manager-sa.display_name
    sa_id = confluent_service_account.app-manager-sa.id
    sa_api_version = confluent_service_account.app-manager-sa.api_version
    sa_kind = confluent_service_account.app-manager-sa.kind

    ## Number of Api Keys
    number_of_api_keys = each.value.number_of_api_keys

    ## Owner privileges
    topic_names_as_owner = each.value.owner.topics
    group_names_as_owner = each.value.owner.groups
    transaction_ids_as_owner = each.value.owner.transaction_ids
    connector_names_as_owner = each.value.owner.connectors
    schema_subjects_as_owner = each.value.owner.schemas

    ## Write privileges
    topic_names_to_write = each.value.write.topics
    transaction_ids_to_write = each.value.write.transaction_ids

    ## Read privileges
    topic_names_to_read = each.value.read.topics
    group_names_to_read = each.value.read.groups
    schema_subjects_to_read = each.value.read.schemas
}