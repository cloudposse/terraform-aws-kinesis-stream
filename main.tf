resource "aws_kinesis_stream" "default" {
  count = module.this.enabled ? 1 : 0

  name                      = module.this.id
  shard_count               = var.stream_mode != "ON_DEMAND" ? var.shard_count : null
  retention_period          = var.retention_period
  shard_level_metrics       = var.shard_level_metrics
  enforce_consumer_deletion = var.enforce_consumer_deletion
  encryption_type           = var.encryption_type
  kms_key_id                = var.kms_key_id

  dynamic "stream_mode_details" {
    for_each = var.stream_mode != null ? ["true"] : []
    content {
      stream_mode = var.stream_mode
    }
  }

  tags = module.this.tags
}

resource "aws_kinesis_stream_consumer" "default" {
  count = module.this.enabled ? var.consumer_count : 0

  name       = format("%s-consumer-%s", module.this.id, count.index)
  stream_arn = try(aws_kinesis_stream.default[0].arn, null)
}
