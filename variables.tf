variable "shard_count" {
  description = "The number of shards that the stream will use"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "Length of time, in hours, that data records are accessible after they are added to the stream. Must be between 24 (the default) and 8760 (365 days)."
  type        = number
  default     = 24

  validation {
    condition     = var.retention_period >= 24 && var.retention_period <= 8760
    error_message = "retention_period must be between 24 and 8760 hours."
  }
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

  validation {
    condition     = contains(["NONE", "KMS"], var.encryption_type)
    error_message = "encryption_type must be `NONE` or `KMS`."
  }
}

variable "kms_key_id" {
  description = "The GUID for the customer-managed KMS key to use for encryption."
  type        = string
  default     = "alias/aws/kinesis"
}

variable "stream_mode" {
  description = "Specifies the capacity mode of the stream. Must be either `PROVISIONED` or `ON_DEMAND`. If `ON_DEMAND` is used, then `shard_count` is ignored. If `null`, the AWS default (`PROVISIONED`) applies."
  type        = string
  default     = null

  validation {
    condition     = var.stream_mode == null || contains(["PROVISIONED", "ON_DEMAND"], var.stream_mode)
    error_message = "stream_mode must be `PROVISIONED`, `ON_DEMAND`, or null."
  }
}

variable "consumer_count" {
  description = "Number of enhanced fan-out consumers to register with the Kinesis stream"
  type        = number
  default     = 0

  validation {
    condition     = var.consumer_count >= 0
    error_message = "consumer_count must be zero or greater."
  }
}
