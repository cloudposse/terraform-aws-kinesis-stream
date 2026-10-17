# Applies examples/complete against the AWS emulator (or real AWS) and checks real behavior by
# reading the stream back through the API. Run with `atmos test`.
#
# Resharding (UpdateShardCount) is also unsupported by the emulator, so only retention is updated.
# Enhanced fan-out consumers are not applied here: the emulator does not implement the Kinesis
# calls the provider makes for them (see tests/stacks/deploy/test.yaml). The mocked tests in the
# repo's tests/main.tftest.hcl cover consumers.

run "create" {
  command = apply

  assert {
    condition     = output.name == "eg-use1-test-example"
    error_message = "Stream name should be the null-label id."
  }

  assert {
    condition     = startswith(output.stream_arn, "arn:aws:kinesis:")
    error_message = "Expected a Kinesis stream ARN."
  }
}

run "stream_exists_with_defaults" {
  command = apply

  module {
    source = "./tests/readback"
  }

  variables {
    stream_name  = run.create.name
    expected_arn = run.create.stream_arn
  }

  assert {
    condition     = output.arn_matches
    error_message = "The API should return the ARN Terraform reported."
  }

  assert {
    condition     = output.shard_count == 2
    error_message = "The stream should have the two requested shards."
  }

  assert {
    condition     = output.retention_period == 24
    error_message = "Default retention should be 24 hours."
  }

  assert {
    condition     = output.status == "ACTIVE"
    error_message = "The stream should be ACTIVE."
  }
}

run "update_in_place" {
  command = apply

  variables {
    retention_period = 48
  }

  assert {
    condition     = output.name == "eg-use1-test-example"
    error_message = "The stream keeps its name when retention changes."
  }
}

run "updates_are_visible_through_the_api" {
  command = apply

  module {
    source = "./tests/readback"
  }

  variables {
    stream_name  = run.update_in_place.name
    expected_arn = run.update_in_place.stream_arn
  }

  assert {
    condition     = output.arn_matches
    error_message = "A retention change must update the stream in place; the ARN must not change."
  }

  assert {
    condition     = output.shard_count == 2
    error_message = "Shard count should be unchanged by a retention update."
  }

  assert {
    condition     = output.retention_period == 48
    error_message = "The API should report the new retention period."
  }
}
