---
from: v0.4.0 (last release of the previous major)
to: v1.0.0
breaking: true
---

# Migrating from v0.4 to v1.0

## Summary

v1.0 raises the minimum Terraform and AWS provider versions and tightens input validation. The resources, their addresses and the outputs are unchanged, so an upgrade needs no `terraform state mv` and, for valid configurations, should produce **no changes** in `terraform plan`.

Affected: everyone. The version floors apply to all users. Validation only affects configurations that were already passing out-of-range values.

## Requirements

| | v0.4 | v1.0 |
|---|---|---|
| Terraform / OpenTofu | `>= 1.0` | `>= 1.9` |
| `hashicorp/aws` provider | `>= 4.0` | `>= 6.0` |

## Breaking changes

| Change | Type | What to do |
|---|---|---|
| Terraform `>= 1.9` required | Requirement | Upgrade Terraform/OpenTofu. |
| AWS provider `>= 6.0` required | Requirement | Upgrade the provider in every root module that uses this module; read the [AWS provider v6 upgrade guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-6-upgrade) for changes in your other resources. |
| `retention_period` must be between 24 and 8760 | Validation added | Values outside the range already failed at apply time in AWS; they now fail at plan time. The documented maximum was also wrong (168); AWS allows 8760 hours. |
| `encryption_type` must be `NONE` or `KMS` | Validation added | Fix any other value. |
| `stream_mode` must be `PROVISIONED`, `ON_DEMAND` or `null` | Validation added | Fix any other value. |
| `consumer_count` must be zero or greater | Validation added | Negative values previously failed in Terraform; the message is now explicit. AWS enforces its own per-stream consumer limit. |

No inputs, outputs or resources were removed, renamed or retyped. Defaults are unchanged.

## Upgrade steps

1. Upgrade Terraform/OpenTofu to 1.9 or later.
2. Upgrade the AWS provider to 6.x in the root module (`required_providers`), then `terraform init -upgrade`.
3. Change the module version:

   ```hcl
   module "kinesis" {
     source  = "cloudposse/kinesis-stream/aws"
     version = "1.0.0"
     # ...
   }
   ```

4. `terraform init -upgrade` and `terraform plan`.

## Verify

`terraform plan` shows **no changes** to `aws_kinesis_stream` or `aws_kinesis_stream_consumer`. Any other diffs come from the AWS provider v6 upgrade in your other resources, not from this module. If validation errors appear, fix the offending input (see the table above).

## Rollback

Pin `version = "0.4.0"` again and restore the previous provider and Terraform constraints. No state changes were made, so no state rollback is needed.

## Examples

`examples/complete` now requires the same Terraform and provider versions.
