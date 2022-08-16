output "name" {
  description = "Name of the Kinesis stream."
  value       = join("", aws_kinesis_stream.default.*.name)
}

output "shard_count" {
  description = "Number of shards provisioned."
  value       = join("", aws_kinesis_stream.default.*.shard_count)
}

output "stream_arn" {
  description = "ARN of the Kinesis stream."
  value       = join("", aws_kinesis_stream.default.*.arn)
}

output "consumers" {
  description = "List of consumers registered with Kinesis stream."
  value       = aws_kinesis_stream_consumer.default
}
