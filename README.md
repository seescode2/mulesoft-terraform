# Terraform labs for MuleSoft Anypoint Platform

These standalone labs use Terraform to call Anypoint Platform APIs with the
[`hashicorp/http`](https://registry.terraform.io/providers/hashicorp/http/latest/docs)
provider. This approach is intentionally read-heavy: it works with a free/trial
Anypoint account and avoids accidentally provisioning billable runtimes, VPCs,
private spaces, or gateways.

## Labs

| Lab | Topic | Changes Anypoint? |
| --- | --- | --- |
| [01-foundations](01-foundations/lab.md) | Credentials, variables, state, and safe workflow | No |
| [02-organization-discovery](02-organization-discovery/lab.md) | Current user, organization, and business groups | No |
| [03-environment-inventory](03-environment-inventory/lab.md) | Environments, filtering, and outputs | No |
| [04-api-manager-inventory](04-api-manager-inventory/lab.md) | Managed API instances and governance | No |
| [05-exchange-inventory](05-exchange-inventory/lab.md) | Exchange assets and reusable API catalogs | No |
| [06-runtime-manager-inventory](06-runtime-manager-inventory/lab.md) | CloudHub applications and hybrid servers | No |
| [07-access-management-inventory](07-access-management-inventory/lab.md) | Users and access review | No |
| [08-platform-audit-report](08-platform-audit-report/lab.md) | Combine APIs and create a local JSON report | Local file only |

## What Terraform can manage on Anypoint

Beyond these free-safe inventory exercises, Terraform providers and/or the
Anypoint REST APIs can automate business groups and environments, users and
roles, connected apps, identity providers, Exchange assets, API Manager
instances/policies/alerts/contracts, Runtime Manager applications, Runtime
Fabrics, CloudHub networking (VPCs, VPNs, transit gateways/private spaces), and
Flex Gateway configuration. Availability depends on your Anypoint edition,
permissions, region, runtime model, and provider version. Those operations are
not provisioned here because they may consume capacity or alter shared tenancy.

## Prerequisites

* Terraform 1.5 or later.
* An Anypoint Platform account and an access token. Generate a short-lived token
  according to your organization's authentication policy; do not commit it.
* Permission to read the APIs used by a lab.

Every folder is an independent root module. Start with its `lab.md`. Copy
`terraform.tfvars.example` to `terraform.tfvars`, which Git ignores, or use
`TF_VAR_access_token`, `TF_VAR_organization_id`, and `TF_VAR_environment_id`.
API paths can evolve; each lab exposes `base_url` and documents how to diagnose
403/404 responses.
