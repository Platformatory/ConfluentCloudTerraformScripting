import pandas as pd
import os
import json

sa_input_file = "sample_service_account_input.csv"

pwd = os.getcwd()

final_credentails_list = []

def fetch_sa_credentials(row):
    app_name = row["application_name"]
    app_folder_name = app_name.replace("/", "\\")
    cluster_url = row["bootstrap_server"]

    credentials_path = os.path.join(pwd, "..", "applications", app_folder_name, "key_details.json")

    if os.path.exists(credentials_path):
        with open(credentials_path, "r") as f:
            key_details = f.read()
            key_details_json = json.loads(key_details)

        # print(key_details_json)

        sa_id = key_details_json["service_account_id"]["value"]
        sa_name = key_details_json["service_account_name"]["value"]

        cluster_list = key_details_json["application_credentials"]["value"].keys()

        for cluster in cluster_list:
            credentials_list = key_details_json["application_credentials"]["value"][cluster]["credentials"]
            for credential in credentials_list:
                data = {
                    "application_name": app_name,
                    "service_account_name": sa_name,
                    "service_account_id": sa_id,
                    "cluster_name": cluster,
                    "bootstrap_server": cluster_url,
                    "sasl_username": credential["key"],
                    "sasl_password": credential["secret"]
                }
                final_credentails_list.append(data)


if __name__ == "__main__":
    sa_details = pd.read_csv(sa_input_file, index_col=[0])

    ## Fetch credentials from each application
    unique_sa_details = sa_details.drop_duplicates("application_name")

    unique_sa_details.apply(fetch_sa_credentials, axis=1)

    credentials_db = pd.DataFrame(final_credentails_list)

    # print(credentials_db.head())

    credentials_db.to_csv("application_credentials.csv")
