from confluent_kafka.admin import AdminClient, ConfigResource
import pandas as pd

final_topics_list = []
topic_db_columns = ["Cluster ID","Topic Name","Topic Config"]

def fetch_topic_details(bootstrap_servers, api_key, api_secret, cluster_name):
    conf = {
        'bootstrap.servers': bootstrap_servers,
        'sasl.username': api_key,
        'sasl.password': api_secret,
        'security.protocol': 'SASL_SSL',
        'sasl.mechanisms': 'PLAIN'
    }

    admin_client = AdminClient(conf)

    topics = admin_client.list_topics().topics

    print("Topic Details:")
    for topic_name, topic_metadata in topics.items():
        data = {}
        data[topic_db_columns[0]] = cluster_name
        data[topic_db_columns[1]] = topic_name
        print(f"Topic Name: {topic_name}")
        partition_count = len(topic_metadata.partitions)
        print(f"Partitions: {partition_count}")

        config_str = "topicConfig: { \"num.partitions\": \"%d\", \"retention.ms\": \"%s\",\"delete.retention.ms\": \"%s\"}"
        topic_configs = admin_client.describe_configs([ConfigResource(ConfigResource.Type.TOPIC, topic_name)])
        for topic_resource, future in topic_configs.items():
            # print(topic_resource.name)
            topic_configs = future.result()
            # print(topic_configs)
            parsed_topic_config = {name: entry.value for name, entry in topic_configs.items()}
        print("Topic Configs:")
        final_config_str = config_str % (partition_count, parsed_topic_config["retention.ms"], parsed_topic_config["delete.retention.ms"])
        print(final_config_str)
        data[topic_db_columns[2]] = final_config_str
        final_topics_list.append(data)

        print("\n")

if __name__ == "__main__":
    ## Input
    bootstrap_servers = 'pkc-12313.ap-southeast-1.aws.confluent.cloud:9092'
    cluster_name = "dp_ingestion"
    api_key = "xxxxxxxxxxxxxxxxx"
    api_secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

    fetch_topic_details(bootstrap_servers, api_key, api_secret, cluster_name)

    df = pd.DataFrame(final_topics_list, columns=topic_db_columns)

    print(df.head())

    df.to_csv("%s_topics.csv" % cluster_name)
