# Test helper: reads a stream back from the API so tests can assert on what AWS (or the emulator)
# actually holds, not only on what Terraform planned.
variable "stream_name" {
  description = "Name of the stream to read back"
  type        = string
}

variable "expected_arn" {
  description = "ARN Terraform reported for the stream; the API must agree"
  type        = string
}

data "aws_kinesis_stream" "this" {
  name = var.stream_name
}

output "arn_matches" {
  description = "Whether the ARN returned by the API equals the expected ARN"
  value       = data.aws_kinesis_stream.this.arn == var.expected_arn
}

output "shard_count" {
  description = "Number of open shards reported by the API"
  value       = length(data.aws_kinesis_stream.this.open_shards)
}

output "retention_period" {
  description = "Retention period in hours reported by the API"
  value       = data.aws_kinesis_stream.this.retention_period
}

output "status" {
  description = "Stream status reported by the API"
  value       = data.aws_kinesis_stream.this.status
}
