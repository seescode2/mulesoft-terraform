# Lab 1: Terraform and Anypoint foundations

## Goal

Learn root modules, providers, input variables, sensitive values, validation,
plans, state, and cleanup without making an Anypoint API request.

## Run the lab

```bash
cd 01-foundations
terraform init
export TF_VAR_access_token='YOUR_SHORT_LIVED_TOKEN'
terraform fmt -check
terraform validate
terraform plan
terraform apply
terraform output control_plane
terraform state list
terraform destroy
```

Terraform will record the variable as sensitive in terminal output, but secrets
can still reach state. Treat state as sensitive, use an encrypted remote backend
for real work, and unset the token when done:

```bash
unset TF_VAR_access_token
rm -rf .terraform .terraform.lock.hcl terraform.tfstate*
```

No Anypoint resource is created. Try `terraform console` and evaluate
`var.base_url`; do not print `var.access_token` in shared terminals.
