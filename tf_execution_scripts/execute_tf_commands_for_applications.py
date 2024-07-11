import pandas as pd
import os

sa_input_file = "sample_service_account_input.csv"
ignore_existing = False

start = 0
end = 317

pwd = os.getcwd()

if not "TF_VAR_confluent_cloud_api_key" in os.environ.keys():
    print("Setup the Confluent Cloud Api Keys as Environment variables")

# os.environ["TF_VAR_confluent_cloud_api_key"] = ""
# os.environ["TF_VAR_confluent_cloud_api_secret"] = ""

commands = [
    'terraform init',
    'terraform validate',
    'terraform plan -out sa_plan',
    'terraform apply -auto-approve -parallelism 10 "sa_plan"',
    'terraform output -json > key_details.json'
]

def execute_sa_tf(row, ignore=ignore_existing, commands_list=commands):
    # print(row)
    app_name = row["application_name"].replace("/", "\\")

    folder = os.path.join(pwd, "..", "applications", app_name)

    if ignore and os.path.exists(os.path.join(folder, "key_details.json")):
        pass
    else:
        # Change directory to the current folder
        os.chdir(folder)
        
        print(f"Executing commands in {folder}:")
        # Execute each command in the list
        for command in commands_list[:]:
            # print(command)
            os.system(command)
        
        # Move back to the parent directory
        os.chdir('..')


if __name__ == "__main__":

    sa_details = pd.read_csv(sa_input_file, index_col=[0])

    ## Execute for each applications
    unique_sa_details = sa_details.drop_duplicates("application_name")

    # print(unique_sa_details)

    unique_sa_details.iloc[start:end].apply(execute_sa_tf, axis=1)
