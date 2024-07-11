// Pass in the Confluent Cloud Api Key and Secret as environment variables




service_account = {
    name = "sa-test-application"
    clusters = [
        ## Create one per each cluster based on the application dependencies
        {
            ## Cluster level details
            environment_id = "env-1wdokj"
            kafka_cluster_id = "lkc-7o1d5p"

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
        },
        {
            ## Cluster level details
            environment_id = "env-oxxwoy"
            kafka_cluster_id = "lkc-n51rp6"

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
