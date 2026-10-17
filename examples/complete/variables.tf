variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "shard_count" {
  description = "The number of shards that the stream will use"
  type        = number
  default     = 1
}

variable "consumer_count" {
  description = "Number of enhanced fan-out consumers to register with the stream"
  type        = number
  default     = 0
}

variable "retention_period" {
  description = "Length of time, in hours, that data records are accessible (24 to 8760)"
  type        = number
  default     = 24
}
