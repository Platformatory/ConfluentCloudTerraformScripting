output "application_credentials" {
  value = {
    kafka_cluster_id = data.confluent_kafka_cluster.dedicated.id
    kafka_cluster_name = data.confluent_kafka_cluster.dedicated.display_name
    credentials = [ for key_pair in confluent_api_key.app-manager-kafka-api-key: { key = key_pair.id, secret = key_pair.secret} ]
  }
  sensitive = true
}
