output "name" {
  description = "Name of the Kinesis stream."
  value       = try(aws_kinesis_stream.default[0].name, null)
}

output "shard_count" {
  description = "Number of shards provisioned."
  value       = try(aws_kinesis_stream.default[0].shard_count, null)
}

output "stream_arn" {
  description = "ARN of the Kinesis stream."
  value       = try(aws_kinesis_stream.default[0].arn, null)
}

output "consumers" {
  description = "List of consumers registered with Kinesis stream."
  value       = aws_kinesis_stream_consumer.default
}
