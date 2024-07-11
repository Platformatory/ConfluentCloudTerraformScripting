// Pass in the Confluent Cloud Api Key, Secret, Cluster admin kafka api key and secret as environment variables

environment_id = "env-1234"
kafka_cluster_id = "lkc-1234"

topics = [
    { name = "topicA", partitions = 1, configs = [{ key = "retention.ms", value = "22222222"}, { key = "min.insync.replicas", value = "1"}] },
    { name = "topicB", partitions = 2, configs = [{ key = "retention.ms", value = "12310924014"}] },
    { name = "topicC", partitions = 3, configs = [{ key = "retention.ms", value = "45454545455"}, { key = "min.insync.replicas", value = "2"}] },
]
