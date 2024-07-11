output "kafka_cluster_details" {
    value = module.dedicated_cluster.kafka_cluster_details
    sensitive = true
}

output "schema_registry_details" {
    value = module.dedicated_cluster.schema_registry_details
}