data "confluent_environment" "default" {
  id = var.environment_id
}

data "confluent_network" "private-service-connect" {
  id = var.network_id
  environment {
    id = data.confluent_environment.default.id
  }
}

data "confluent_schema_registry_region" "default" {
  cloud   = data.confluent_network.private-service-connect.cloud
  region  = data.confluent_network.private-service-connect.region
  package = var.schema_registry_package
}