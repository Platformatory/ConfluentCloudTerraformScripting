output "kafka_cluster_details" {
  value = {
    kafka_cluster_id = confluent_kafka_cluster.dedicated.id
    cluster_admin_sa_name = confluent_service_account.app-manager.display_name
    cluster_admin_sa_id = confluent_service_account.app-manager.id
    cluster_admin_api_key = confluent_api_key.app-manager-kafka-api-key.id
    cluster_admin_api_secret = confluent_api_key.app-manager-kafka-api-key.secret
  }

  sensitive = true
}

output "schema_registry_details" {
  value = {
    schema_registry_id = one(confluent_schema_registry_cluster.essentials[*].id)
    schema_registry_rest_endpoint = one(confluent_schema_registry_cluster.essentials[*].rest_endpoint)
  }
}

