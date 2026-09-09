# Lab 2: Discover your organization

## Goal

Use Terraform as a read-only API client. Decode JSON, use `try`, transform a
collection with a `for` expression, and discover IDs needed by later labs.

## Run the lab

```bash
cd 02-organization-discovery
terraform init
export TF_VAR_access_token='YOUR_SHORT_LIVED_TOKEN'
terraform plan
terraform apply
terraform output identity
```

Copy the organization ID for later labs. Then run `terraform destroy`; this only
removes the data source from local state.

## Troubleshooting

* `401`: refresh the token.
* `403`: request organization-view permission.
* `404`: set `base_url` to your region's Anypoint control plane.
* JSON shape errors: inspect only non-secret response metadata with
  `terraform console`; API payloads differ by account generation.
