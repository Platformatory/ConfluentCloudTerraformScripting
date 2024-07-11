# Confluent Cloud Terraform Scripts

## Overview
This is a tool designed for migrating Kafka clusters, topics and role bindings. 

## Prerequisites
Before you begin, ensure you have the following installed:
- Python 3.6 or later
- Terraform

## Install the dependencies

```bash
pip install -r requirements.txt
```

## Configure the environment

- Set the Confluent Cloud credentials as environment variables.

```
export TF_VAR_confluent_cloud_api_key="xxxxxxxxxxxxxx"
export TF_VAR_confluent_cloud_api_secret="xxxxxxxxxxxxx"
```

- Also, set the paralleism to 3 for terraform commands to avoid failure beacuse of rate limiting issues from Confluent

```
export TF_CLI_ARGS_plan="-parallelism=3"
export TF_CLI_ARGS_apply="-parallelism=3"
```

## Usage

### Cluster and Topic provisioning

Under `resources` folder, every cluster will be a separate folder. And inside each folder there will be separate folders for,

- cluster
- topic

**Note**: `modules` folder contains the common scripts and should not be modified unless necessary.

For any new clusters, make a copy of the `cluster_1` folder and rename the folder accordingly.

**All the below commands will be shown in the context of `cluster_1` for example purposes. Please follow the same for any other cluster replacing the cluster name accordingly** 

### For cluster provisioning

- Navigate to `cluster` folder under the `resources/cluster_1` folder.
- Update the `terraform.tfvars` file with the cluster related information

```
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

  ## (Optional) Deploy schema registry - Boolean - Default is "false"
  ## deploy_schema_registry = true

  ## (Optional) Type of the Schema Registy package for the Schema registry cluster. Valid values are "ESSENTIALS" and "ADVANCED". Default is "ESSENTIALS"
  ## schema_registry_package = "ADVANCED"
}
```
**Note**: Some regions might support only "ADVANCED" schema registry package. The list of regions and the available SR packages can be found in this [link](https://docs.confluent.io/cloud/current/stream-governance/packages.html#cloud-providers-and-region-support)


- Run terraform script using the following commands
```
terraform init
terraform validate
terraform plan
terraform apply
```

- Output the Kafka cluster details to a file
```
terraform output -json > ./cluster_details.json
```

- The `cluster_details.json` will contain the cluster details and the cluster level Kafka API Key and Secret. This credential should be used for provisioning the cluster topics next.

### For topic provisioning

#### Parse the topics into terraform compatible format

- Sample input for the topic list can be found at `topic_parser/sample_raw_topic.csv`. This format must be maintained for the parser to work. Only "CSV" format is supported.

- Navigate to `topic_parser` folder and run the following command,
```
python parse_topics.py -t <path_to_topic_list_csv> -e <confluent_environment_id> -k <kafka_cluster_id> -i <cluster-kafka-api-key> -s <cluster-kafka-api-secret>
```

- The above command will generate a `terraform.tfvars.sample` file in the same path.

- Copy the contents of the `terraform.tfvars.sample` file and replace the `terraform.tfvars` file at `resources/cluster_1/topics`.


#### Provision the topics 

- Navigate to `topics` folder under the `resources/cluster_1` folder.

- Run terraform script using the following commands
```
terraform init
terraform validate
terraform plan
terraform apply
```

- Output the topic ids to a file
```
terraform output -json > ./topic_details.json
```

### Service Account Provisioning

#### Points to note
- A sample input for the Confluent Service Account (SA) provisioning can be found at `tf_execution_scripts/sample_service_account_input.csv`. This format must be maintained for the subsequent scripts to work. Only "CSV" format is supported.
    
    - In the input file, each row represents a cluster level dependency for an application. For example, if an application talks to topics across 2 clusters, there will be 2 entries in the input file.
    
    - Common prefixes should be identified from the list of topic names to reduce the number of RoleBindings required per SA.
    
    - The `write_topics_final` and `read_topics_final` columns will contain the finalized list of topic names(prefixes)
    
    - SA name cannot have more than 64 characters as this a limit enforced by Confluent

    - Any 2 different applications cannot have the same SA name

- One SA will be provisoned for each application

- Each application will have a separate folder under `applications` folder. Any changes to application level can be directly done inside the application level folder if necessary

- One API Key and Secret will be provisioned for each row in the input file

#### Execution steps

All of the below commands assumes the input file as `sample_service_account_input.csv`. The input file path can be changed inside the respective python file. 

All the below commands will be executed from inside the `tf_execution_scripts` folder.

1. Find topic prefixes for the given list of topic names

    - The below script will extract prefixes for the given list of topics. But, the extracted prefixes cannot be considered final and will need manual validation. This script is only meant as a means to ease the prefix identification process

      ```
      python3 find_topic_prefix.py
      ```

2. Validate SA names
    
    - The below script will check for any SA names with over 64 characters and if it is duplicated for 2 different applications

      ```
      python3 validate_service_account_names.py
      ``` 

3. Generate a folder per application inside `applications` folder

    - The below script will copy the contents of `applications/application_1` folder and create a new folder for each application

      ```
      python3 generate_tf_folder_per_application.py
      ```

    - Also, based on the contents in the input file, it will create the `terraform.tfvars` file for each application.

    - A sample `terraform.tfvars` file for an application can be found below,

      ```
      // Pass in the Confluent Cloud Api Key and Secret as environment variables

      service_account = {
          name = "sa-test-application"
          clusters = [
              ## Create one per each cluster based on the application dependencies
              {
                  ## Cluster level details
                  environment_id = "env-12414"
                  kafka_cluster_id = "lkc-1241"

                  ## Need to be provided for any schema related role bindings. Otherwise the operation will fail
                  schema_registry_cluster_id = ""

                  ## Number of api keys for the applicaiton in the given cluster
                  number_of_api_keys = 1

                  ## Resources owned by application in the given cluster. Accepted values = Prefixed - "test*", Literal - "alpha-topic"
                  owner = {
                      topics = ["test*"]
                      groups = ["test*"]
                      transaction_ids = []
                      connectors = []
                      
                      ## "schema_registry_cluster_id" value should not be empty
                      schemas = []
                  }

                  ## Resources written to by application in the given cluster. Accepted values = Prefixed - "test*", Literal - "alpha-topic"
                  write = {
                      topics = ["sample*"]
                      transaction_ids = []
                  }

                  ## Resources read by application in the given cluster. Accepted values = Prefixed - "test*", Literal - "alpha-topic"
                  read = {
                      topics = ["alpha-topic"]
                      groups = ["*"]

                      ## "schema_registry_cluster_id" value should not be empty
                      schemas = []
                  }
              }
          ]
      }
      ```

4. Execute the terraform commands to create SA and its credentials

    - The below script will navigate to each application folder and execute the terraform commands to create the SA and its credentials.

      ```
      python3 execute_tf_commands_for_applications.py
      ```
    
    - The script will basically store the created SA credentials in a file called `key_details.json` inside each application folder

5. Populate the SA credentials into a CSV file

    - After the creation of SA and its credentails, the below script will fetch the credentials details from each application folder and populate it into a CSV file

      ```
      python3 populate_application_credentials_from_tf_output.py
      ```
    
    - The generated CSV file will have the same number of rows as the inital input file provided

6. Post the SA credentails to the Meesho Rest API

    - This script will post the populated SA credentials to the REST API provided by the Meesho team. 

      ```
      python3 post_kafka_credentials_to_api.py
      ``` 

## Important notes

- All the above artefacts are specifically designed as per the requirements from the Meesho team. These artefacts are out-of-scope with regards to coverage from Confluent Support. 

- Additionally, all the artefacts were prepared in the scope of this particular migration activity and inherently do not extend as a standard deployment pipeline for further usage. Kindly request the Meesho team to maintain and improve the artefacts if they wish to use it for their CI/CD pipelines.

- The Python artefacts are not optimized for code reusability and modularization as this was prepared on a best effort basis in a reduced timeline.