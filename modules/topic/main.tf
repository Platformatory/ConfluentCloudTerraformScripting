resource "confluent_kafka_topic" "topic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.default.id
  }

  rest_endpoint = data.confluent_kafka_cluster.default.rest_endpoint
  topic_name = var.topic_name
  partitions_count = var.partition_count
  config = var.topic_configs

  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}