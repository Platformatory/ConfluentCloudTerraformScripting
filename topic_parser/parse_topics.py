import pandas as pd
import argparse
import json
from jinja2 import Template

parser = argparse.ArgumentParser()
parser.add_argument("--env_id", "-e", dest="env_id", type=str, required=True, help="Confluent Environment ID")
parser.add_argument("--kafka_cluster_id", "-k", dest="kafka_id", type=str, required=True, help="Confluent Kafka Cluster ID")
parser.add_argument("--topic_csv_file", "-t", dest="topic_file", type=str, required=True, help="Path to the raw topics CSV file")
parser.add_argument("--kafka_api_key", "-i", dest="api_key", type=str, required=True, help="Kafka Api Key of the Cluster")
parser.add_argument("--kafka_api_secret", "-s", dest="api_secret", type=str, required=True, help="Kafka Api Secret of the Cluster")

args = parser.parse_args()

template_file_path = "../tf_templates/topics.tf.tpl"

topic_chain_str = ""

total_partitions_count = 0

def parse_each_row(row):
    # print(row)
    global topic_chain_str
    global total_partitions_count
    name = row["Topic Name"]
    raw_configs = row["Topic Config"]

    topic_name = str(name).strip()
    split_configs = raw_configs.split("topicConfig:")[1].strip()
    
    if split_configs == "null" or split_configs == "null,":
        pass
    else:
        split_configs = split_configs.replace(",retention", ",\"retention").replace(",delete", ",\"delete")
        # print(split_configs)
        configs_json = json.loads(split_configs)

        partitions = int(configs_json.pop("num.partitions"))

        total_partitions_count = total_partitions_count + partitions

        intital_str = ""
        for key, value in configs_json.items():
             intital_str = intital_str + "{key = \"%s\", value = \"%s\"}," % (key, value)

        config_list_str = "[{0}]".format(intital_str)
        
        processed_config_str = "{ name = \"%s\", partitions = %d, configs = %s},\n" % (topic_name, partitions, config_list_str)

        topic_chain_str = topic_chain_str + processed_config_str


if __name__ == "__main__":
    raw_data = pd.read_csv(args.topic_file, index_col=[0])

    # Remove duplicates
    print("Total topics: %d" % raw_data.shape[0])

    print("Checking for duplicates")

    data = raw_data.drop_duplicates(subset=["Topic Name"])

    print("Total topics after removing duplicates: %d" % data.shape[0])

    data.apply(parse_each_row, axis=1)
    
    print("Total partition count: %d" % total_partitions_count)

    final_topics_str = "[%s]" % topic_chain_str

    with open(template_file_path, "r") as f:
        content = f.read()

    template = Template(content)
    rendered_file = template.render(env_id=args.env_id,kafka_id=args.kafka_id,kafka_api_key=args.api_key,kafka_api_secret=args.api_secret,topics=final_topics_str)

    with open("terraform.tfvars.sample", "w+") as f:
        f.write(rendered_file)
    
    print("File sucessfully written")
