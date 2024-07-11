data "confluent_kafka_cluster" "default" {
  id = var.kafka_cluster_id
  
  environment {
    id = var.environment_id
  }
}