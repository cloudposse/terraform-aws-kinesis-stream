---
from: v0.4.0 (last release of the previous major)
to: v1.0.0
breaking: true
---

# Migrating from v0.4 to v1.0

## Summary

v1.0 raises the minimum AWS provider version, tightens input validation, and makes the `name` and `stream_arn` outputs `null` (not `""`) when the module is disabled. Resources and their addresses are unchanged, so no `terraform state mv` is needed and, for an enabled module with valid inputs, `terraform plan` should show **no changes**.

Affected: everyone (provider floor). The validation and output changes affect only callers that pass out-of-range values or that read `name` / `stream_arn` while `enabled = false`.

## Requirements

| | v0.4 | v1.0 |
|---|---|---|
| Terraform / OpenTofu | `>= 1.0` | `>= 1.0.0` (unchanged) |
| `hashicorp/aws` provider | `>= 4.0` | `>= 6.0.0` |

## Breaking changes

| Change | Type | What to do |
|---|---|---|
| AWS provider `>= 6.0.0` required | Requirement | Upgrade the provider in every root module that uses this module. Read the [AWS provider v6 upgrade guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-6-upgrade) for changes to your other resources. |
| Outputs `name` and `stream_arn` are `null` instead of `""` when `enabled = false` | Output value | Replace comparisons with `""` by `== null`, or wrap with `coalesce`/`try`. Enabled modules are unaffected. |
| `retention_period` must be between 24 and 8760 | Validation added | Values outside the range already failed at apply time in AWS; they now fail at plan time. The documented maximum was also wrong (168); AWS allows 8760 hours. |
| `encryption_type` must be `NONE` or `KMS` | Validation added | Fix any other value. |
| `stream_mode` must be `PROVISIONED`, `ON_DEMAND` or `null` | Validation added | Fix any other value. |
| `consumer_count` must be zero or greater | Validation added | Negative values previously failed in Terraform; the message is now explicit. AWS enforces its own per-stream consumer limit. |

No inputs or resources were removed, renamed or retyped. Defaults are unchanged.

## Upgrade steps

1. Upgrade the AWS provider to 6.x in the root module (`required_providers`), then `terraform init -upgrade`.
2. Change the module version:

   ```hcl
   module "kinesis" {
     source  = "cloudposse/kinesis-stream/aws"
     version = "1.0.0"
     # ...
   }
   ```

3. `terraform init -upgrade` and `terraform plan`.

## Verify

`terraform plan` shows **no changes** to `aws_kinesis_stream` or `aws_kinesis_stream_consumer`. Any other diffs come from the AWS provider v6 upgrade in your other resources, not from this module. If validation errors appear, fix the offending input (see the table above).

## Rollback

Pin `version = "0.4.0"` again and restore the previous provider and Terraform constraints. No state changes were made, so no state rollback is needed.

## Examples

`examples/complete` now requires the same provider version and takes `consumer_count` and `retention_period` inputs.
