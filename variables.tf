variable "shard_count" {
  description = "The number of shards that the stream will use"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream. The maximum value of a stream's retention period is 168 hours. Minimum value is 24. Default is 24."
  type        = number
  default     = 24
}

variable "shard_level_metrics" {
  description = "A list of shard-level CloudWatch metrics which can be enabled for the stream."
  type        = list(string)
  default = [
    "IncomingBytes",
    "OutgoingBytes"
  ]
}

variable "enforce_consumer_deletion" {
  description = "A boolean that indicates all registered consumers should be deregistered from the stream so that the stream can be destroyed without error."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type to use. Acceptable values are `NONE` and `KMS`."
  type        = string
  default     = "KMS"
}

variable "kms_key_id" {
  description = "The GUID for the customer-managed KMS key to use for encryption."
  type        = string
  default     = "alias/aws/kinesis"
}

variable "stream_mode" {
  description = "Specifies the capacity mode of the stream. Must be either `PROVISIONED` or `ON_DEMAND`. If `ON_DEMAND` is used, then `shard_count` is ignored."
  type        = string
  default     = null
}
