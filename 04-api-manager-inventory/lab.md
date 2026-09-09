# Lab 4: Inventory API Manager

## Goal

Read managed API instances in one environment and learn why organization and
environment context headers matter.

## Run the lab

```bash
cd 04-api-manager-inventory
cp terraform.tfvars.example terraform.tfvars
# Fill in all three values.
terraform init
terraform plan
terraform apply
terraform output -json api_instances
terraform destroy
```

An empty list is valid for a free account. A 403 generally means the identity
lacks API Manager Viewer permission.

## What production automation adds

A mature module can manage API instances, endpoints, policies, policy ordering,
SLA tiers/contracts, client applications, alerts, and automated policies. Those
changes can affect live traffic, so this lab only inventories instances. Import
existing objects before management and test policies in a sandbox first.
