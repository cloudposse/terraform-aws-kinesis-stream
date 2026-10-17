module "kinesis" {
  source = "../.."

  shard_count      = var.shard_count
  consumer_count   = var.consumer_count
  retention_period = var.retention_period

  context = module.this.context
}
