output "topic_id" {
    value = confluent_kafka_topic.topic.id
}

output "topic_name" {
    value = confluent_kafka_topic.topic.topic_name
}