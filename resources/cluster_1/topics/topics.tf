module "topics" {
    source = "../../../modules/topic"

    for_each = { for t in var.topics : t.name => t }

    environment_id = var.environment_id
    kafka_cluster_id = var.kafka_cluster_id
    kafka_api_key = var.admin_kafka_api_key
    kafka_api_secret = var.admin_kafka_api_secret

    topic_name = each.key
    partition_count = each.value.partitions
    topic_configs = { for config in each.value.configs: config.key => config.value }
}