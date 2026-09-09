# Lab 6: Inventory Runtime Manager

## Goal

Inspect CloudHub applications without deploying one, and learn `count` as an
opt-in switch for an endpoint that may not exist in your account.

## Run the lab

```bash
cd 06-runtime-manager-inventory
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform output -json applications
terraform destroy
```

Set `include_hybrid_servers = true` only if your account uses hybrid runtimes.
A 404/403 for CloudHub can mean the environment uses a different runtime model
or your role lacks Runtime Manager read access.

## Production capability map

Terraform automation may deploy/update applications, properties, replicas and
worker sizes; configure CloudHub 2.0 private spaces; register Runtime Fabric;
and manage VPCs, firewall rules, load balancers, VPNs, and transit connectivity.
These are capacity-consuming or security-sensitive, so they are intentionally
not created with a free account.
