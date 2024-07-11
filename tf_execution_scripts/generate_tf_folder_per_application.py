import os
import pandas as pd
import shutil
from jinja2 import Template

sa_input_file = "sample_service_account_input.csv"

pwd = os.getcwd()

characters_to_replace = ["_", ".", "/"]
num_of_api_keys = 1

def copy_folder(source_folder, destination_folder):
    try:
        # Copy the entire folder and its contents to the destination
        shutil.copytree(source_folder, destination_folder)
        print(f"Folder '{source_folder}' copied to '{destination_folder}' successfully.")
    except shutil.Error as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

def join_topics_into_str(topic_list):
    topic_str = ""

    for topic in topic_list:
        if len(topic) > 0:
            topic_str = topic_str + " \"%s\"," %  topic

    return topic_str

def generate_sa_tf_folder(row):
    global num_of_api_keys
    
    app_name = row["application_name"].iloc[0].replace("/", "\\")
    sa_name = row["service_account_name"].iloc[0]

    # copy subdirectory example
    from_directory = os.path.join(pwd, "..", "applications", "application_1")
    to_directory = os.path.join(pwd, "..", "applications", app_name)

    if not os.path.exists(to_directory):
        copy_folder(from_directory, to_directory)
    else:
        print("%s folder already exists" % app_name)

    cluster_rb_str = ""

    for i in range(row.shape[0]):
        env_id = row["env_id"].iloc[i]
        cluster_id = row["cluster_id"].iloc[i]
        write_topics = str(row["write_topics_final"].iloc[i])
        if write_topics != "None" and write_topics != "nan":
            write_topics = write_topics.split(",")
        else:
            write_topics = []
        read_topics = str(row["read_topics_final"].iloc[i])
        if read_topics != "None" and read_topics != "nan":
            read_topics = read_topics.split(",")
        else:
            read_topics = []

        group_str = ""
        write_topics_str = join_topics_into_str(write_topics)
        read_topics_str = join_topics_into_str(read_topics)

        if len(read_topics) > 0:
            group_str = "\"*\""

        with open(os.path.join(pwd, "..", "tf_templates", "rolebindings.tf.tpl"), "r") as f:
            rb_content = f.read()
            rb_template = Template(rb_content)
        
        rb_rendered_file = rb_template.render(env_id=env_id, cluster_id=cluster_id, num_of_api_keys=num_of_api_keys, write_topics=write_topics_str, read_topics=read_topics_str, read_groups=group_str)
        # print(rb_rendered_file)

        cluster_rb_str = cluster_rb_str + rb_rendered_file + ",\n"

    with open(os.path.join(pwd, "..", "tf_templates", "sa.tf.tpl"), "r") as f:
        sa_content = f.read()
        sa_template = Template(sa_content)    

    sa_rendered_file = sa_template.render(sa_name=sa_name, sa_role_bindings=cluster_rb_str)
    # print(sa_rendered_file)

    with open(os.path.join(to_directory, "terraform.tfvars"), "w+") as f:
        f.write(sa_rendered_file)


if __name__=="__main__":
    sa_details = pd.read_csv(sa_input_file, index_col=[0])

    grouped_sa_details = sa_details.groupby(["application_name", "service_account_name"]).apply(generate_sa_tf_folder)
