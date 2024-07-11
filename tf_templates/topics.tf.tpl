// Pass in the Confluent Cloud Api Key, Secret, Cluster admin kafka api key and secret as environment variables

environment_id = "{{ env_id }}"
kafka_cluster_id = "{{ kafka_id }}"

admin_kafka_api_key = "{{ kafka_api_key }}"
admin_kafka_api_secret = "{{ kafka_api_secret }}"

topics = {{ topics }}
