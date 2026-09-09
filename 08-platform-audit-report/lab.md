# Lab 8: Compose a platform audit report

## Goal

Combine multiple Anypoint APIs into one Terraform dependency graph and write a
minimal local report with restrictive permissions. This demonstrates local
resources, derived values, and how a platform team can feed compliance systems.

## Run the lab

```bash
cd 08-platform-audit-report
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
cat anypoint-audit.json
stat -c '%a %n' anypoint-audit.json
terraform destroy
```

Destroy removes the generated report. The report and all tfvars/state files are
ignored by Git. Although this sample contains only IDs and counts, real API
responses and state may contain personal or confidential data.

## Extend it safely

Add read-only data calls one at a time for Exchange, runtimes, policies, alerts,
networking, and access assignments. Normalize only required fields, mark
sensitive outputs, store state remotely with encryption and locking, pin
providers, run speculative plans in CI, and require approval before any write.
