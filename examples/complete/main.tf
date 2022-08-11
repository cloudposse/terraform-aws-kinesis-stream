module "kinesis" {
  source = "../.."

  shard_count = var.shard_count

  context = module.this.context
}
