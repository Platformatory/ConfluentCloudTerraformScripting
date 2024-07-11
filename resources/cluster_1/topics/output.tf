output "topics" {
    value = { for topic in module.topics: topic.topic_name => topic.topic_id}
}