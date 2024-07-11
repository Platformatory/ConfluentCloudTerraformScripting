// Pass in the Confluent Cloud Api Key and Secret as environment variables

service_account = {
    name = "{{ sa_name }}"
    clusters = [
        ## Create one per each cluster based on the application dependencies
{{ sa_role_bindings }}
    ]
}
