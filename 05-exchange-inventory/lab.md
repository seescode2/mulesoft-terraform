# Lab 5: Inventory Anypoint Exchange

## Goal

Discover reusable Exchange assets such as API specifications, fragments,
examples, connectors, templates, and policies. Learn query parameters and
bounded reads (`limit`) to keep a lab small.

## Run the lab

```bash
cd 05-exchange-inventory
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform output -json assets
terraform destroy
```

Increase `limit` carefully. Exchange may return only assets visible to your
account. In production, Terraform can coordinate publication/versioning and use
asset coordinates to create API Manager instances; immutable versions and CI
artifact checks are preferable to overwriting published assets.
