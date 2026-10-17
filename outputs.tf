output "name" {
  description = "Name of the Kinesis stream, or `null` when the module is disabled"
  value       = one(aws_kinesis_stream.default[*].name)
}

output "shard_count" {
  description = "Number of shards provisioned, or `null` when the module is disabled or the stream is `ON_DEMAND`"
  value       = one(aws_kinesis_stream.default[*].shard_count)
}

output "stream_arn" {
  description = "ARN of the Kinesis stream, or `null` when the module is disabled"
  value       = one(aws_kinesis_stream.default[*].arn)
}

output "consumers" {
  description = "List of enhanced fan-out consumers registered with the stream (empty when none are requested or the module is disabled)"
  value       = aws_kinesis_stream_consumer.default
}
