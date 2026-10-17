variable "region" {
  type        = string
  description = "AWS region"
}

variable "shard_count" {
  description = "The number of shards that the stream will use"
  type        = number
  default     = 1
}
