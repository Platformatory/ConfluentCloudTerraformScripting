data "confluent_environment" "default" {
  id = var.environment_id
}

data "confluent_kafka_cluster" "dedicated" {
  id = var.kafka_cluster_id
  
  environment {
    id = data.confluent_environment.default.id
  }
}

data "confluent_schema_registry_cluster" "default" {
  count = var.schema_registry_cluster_id != null && length(var.schema_registry_cluster_id) > 1 ? 1 : 0

  id = var.schema_registry_cluster_id

  environment {
    id = data.confluent_environment.default.id
  }
}