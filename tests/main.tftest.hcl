# Unit tests: no AWS access needed (mocked provider).

mock_provider "aws" {
  mock_resource "aws_kinesis_stream" {
    defaults = {
      arn = "arn:aws:kinesis:us-east-1:111111111111:stream/eg-test-example"
    }
  }
}

variables {
  namespace   = "eg"
  environment = "use1"
  stage       = "test"
  name        = "example"
}

run "enabled_creates_stream" {
  command = apply

  variables {
    shard_count = 2
  }

  assert {
    condition     = length(aws_kinesis_stream.default) == 1
    error_message = "Expected one stream when enabled."
  }

  assert {
    condition     = aws_kinesis_stream.default[0].name == "eg-use1-test-example"
    error_message = "Stream name should come from the null-label id."
  }

  assert {
    condition     = output.shard_count == 2
    error_message = "shard_count output should reflect the input."
  }

  assert {
    condition     = length(aws_kinesis_stream_consumer.default) == 0
    error_message = "No consumers by default."
  }
}

run "disabled_creates_nothing" {
  command = apply

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_kinesis_stream.default) == 0 && length(aws_kinesis_stream_consumer.default) == 0
    error_message = "Nothing should be created when enabled = false."
  }

  assert {
    condition     = output.name == null && output.stream_arn == null && output.shard_count == null
    error_message = "Name, ARN and shard_count outputs should be null when disabled."
  }
}

run "consumers_are_registered" {
  command = apply

  variables {
    consumer_count = 3
  }

  assert {
    condition     = length(aws_kinesis_stream_consumer.default) == 3
    error_message = "Expected three consumers."
  }

  assert {
    condition     = aws_kinesis_stream_consumer.default[2].name == "eg-use1-test-example-consumer-2"
    error_message = "Consumer names should be suffixed with their index."
  }
}

run "on_demand_ignores_shard_count" {
  command = plan

  variables {
    stream_mode = "ON_DEMAND"
    shard_count = 4
  }

  assert {
    condition     = aws_kinesis_stream.default[0].shard_count == null
    error_message = "shard_count must not be set in ON_DEMAND mode."
  }
}

run "rejects_bad_encryption_type" {
  command = plan

  variables {
    encryption_type = "AES"
  }

  expect_failures = [var.encryption_type]
}

run "rejects_out_of_range_retention" {
  command = plan

  variables {
    retention_period = 10
  }

  expect_failures = [var.retention_period]
}
