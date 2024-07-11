## Pass in the Confluent Cloud Api Key and Secret as environment variables

cluster_details = {
  ## The Environment ID of the Confluent environment
  environment_id = "env-31233"

  ## The Network ID of the Confluent network for the above Confluent environment
  network_id = "n-2131"

  ## Name of the dedicated kafka cluster
  kafka_cluster_name = "test"

  ## (Optional) Availability type of the dedicated kafka cluster - Valid value are "SINGLE_ZONE" and "MULTI_ZONE". Default is "SINGLE_ZONE"
  kafka_cluster_availability = "MULTI_ZONE"

  ## (Optional) Number of CKU's for the Kafka cluster
  ## number_of_ckus = 2

  ## (Optional) Deploy schema registry - Boolean - Default is "false"
  ## deploy_schema_registry = true

  ## (Optional) Type of the Schema Registy package for the Schema registry cluster. Valid values are "ESSENTIALS" and "ADVANCED". Default is "ESSENTIALS"
  ## schema_registry_package = 
}