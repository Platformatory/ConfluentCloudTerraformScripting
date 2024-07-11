// Create admin service account for the Kafka cluster
resource "confluent_service_account" "app-manager" {
  display_name = "${data.confluent_kafka_cluster.dedicated.display_name}-cluster-admin"
  description  = "Service account to manage the '${data.confluent_kafka_cluster.dedicated.display_name}' Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = data.confluent_kafka_cluster.dedicated.rbac_crn
}

resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "admin-kafka-api-key"
  description  = "Kafka API Key that is owned by '${data.confluent_kafka_cluster.dedicated.display_name}-cluster-admin' service account"
  disable_wait_for_ready = true
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.dedicated.id
    api_version = data.confluent_kafka_cluster.dedicated.api_version
    kind        = data.confluent_kafka_cluster.dedicated.kind

    environment {
      id = data.confluent_environment.default.id
    }
  }

  # The goal is to ensure that confluent_role_binding.app-manager-kafka-cluster-admin is created before
  # confluent_api_key.app-manager-kafka-api-key is used to create instances of
  # confluent_kafka_topic resources.
  depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin,
  ]
}

resource "confluent_schema_registry_cluster" "essentials" {
  count = var.deploy_schema_registry ? 1 : 0

  package = data.confluent_schema_registry_region.default.package

  environment {
    id = data.confluent_environment.default.id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    # Schema Registry and Kafka clusters can be in different regions as well as different cloud providers,
    # but you should to place both in the same cloud and region to restrict the fault isolation boundary.
    id = data.confluent_schema_registry_region.default.id
  }

  lifecycle {
    prevent_destroy = true
  }
}
