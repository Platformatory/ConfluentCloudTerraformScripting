output "service_account_id" {
    value = confluent_service_account.app-manager-sa.id
}

output "service_account_name" {
    value = confluent_service_account.app-manager-sa.id
}

output "application_credentials" {
    value = { for cluster in module.sa_role_bindings: cluster.application_credentials.kafka_cluster_name => cluster.application_credentials}
    sensitive = true
}