terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

variable "access_token" {
  description = "Short-lived Anypoint bearer token. Prefer TF_VAR_access_token."
  type        = string
  sensitive   = true
}

variable "base_url" {
  description = "Anypoint control-plane URL; use the URL appropriate for your region."
  type        = string
  default     = "https://anypoint.mulesoft.com"
}

locals {
  request_headers = {
    Accept        = "application/json"
    Authorization = "Bearer ${var.access_token}"
  }
}

variable "organization_id" {
  type = string
}
variable "environment_id" {
  type = string
}

data "http" "environments" {
  url = "${var.base_url}/accounts/api/organizations/${var.organization_id}/environments"
  request_headers = merge(local.request_headers, { "X-ANYPNT-ORG-ID" = var.organization_id })
}
data "http" "apis" {
  url = "${var.base_url}/apimanager/api/v1/organizations/${var.organization_id}/environments/${var.environment_id}/apis"
  request_headers = merge(local.request_headers, {
    "X-ANYPNT-ORG-ID" = var.organization_id
    "X-ANYPNT-ENV-ID" = var.environment_id
  })
}
locals {
  env_payload = jsondecode(data.http.environments.response_body)
  api_payload = jsondecode(data.http.apis.response_body)
  report = {
    generated_by    = "Terraform"
    organization_id = var.organization_id
    environment_id  = var.environment_id
    environment_count = length(try(local.env_payload.data, local.env_payload, []))
    api_instance_count = length(try(local.api_payload.assets, local.api_payload.data, []))
  }
}
resource "local_sensitive_file" "audit" {
  filename        = "${path.module}/anypoint-audit.json"
  content         = jsonencode(local.report)
  file_permission = "0600"
}
output "report_path" {
  value = local_sensitive_file.audit.filename
}
