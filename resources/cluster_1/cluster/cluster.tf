module "dedicated_cluster" {
    source = "../../../modules/cluster"

    environment_id = var.cluster_details.environment_id
    network_id = var.cluster_details.network_id
    kafka_cluster_name = var.cluster_details.kafka_cluster_name
    kafka_cluster_availability = var.cluster_details.kafka_cluster_availability
    num_of_ckus = var.cluster_details.number_of_ckus
    deploy_schema_registry = var.cluster_details.deploy_schema_registry
    schema_registry_package = var.cluster_details.schema_registry_package
}