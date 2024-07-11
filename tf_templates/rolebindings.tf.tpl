        {
            ## Cluster level details
            environment_id = "{{ env_id }}"
            kafka_cluster_id = "{{ cluster_id }}"

            ## Need to be provided for any schema related role bindings. Otherwise the operation will fail
            schema_registry_cluster_id = ""

            ## Number of api keys for the applicaiton in the given cluster
            number_of_api_keys = {{ num_of_api_keys }}

            ## Resources owned by application in the given cluster. Accepted values = Prefixed - "test*", Literal - "alpha-topic"
            owner = {
                topics = []
                groups = []
                transaction_ids = []
                connectors = []
                
                ## "schema_registry_cluster_id" value should not be empty
                schemas = []
            }

            ## Resources written to by application in the given cluster. Accepted values = Prefixed - "test*", Literal - "alpha-topic"
            write = {
                topics = [{{ write_topics }}]
                transaction_ids = []
            }

            ## Resources read by application in the given cluster. Accepted values = Prefixed - "test*", Literal - "alpha-topic"
            read = {
                topics = [{{ read_topics }}]
                groups = [{{ read_groups }}]

                ## "schema_registry_cluster_id" value should not be empty
                schemas = []
            }
        }
