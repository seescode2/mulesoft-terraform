terraform {
  required_version = ">= 1.5.0"
  required_providers {
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
  description = "Business group/organization ID containing the environments."
  type        = string
}
variable "environment_type" {
  description = "Optional type filter, for example sandbox or production; empty means all."
  type        = string
  default     = ""
}

data "http" "environments" {
  url = "${var.base_url}/accounts/api/organizations/${var.organization_id}/environments"
  request_headers = merge(local.request_headers, {
    "X-ANYPNT-ORG-ID" = var.organization_id
  })
}

locals {
  environment_payload = jsondecode(data.http.environments.response_body)
  environments        = try(local.environment_payload.data, local.environment_payload)
  selected = [for env in local.environments : {
    id   = env.id
    name = env.name
    type = try(env.type, null)
  } if var.environment_type == "" || lower(try(env.type, "")) == lower(var.environment_type)]
}
output "environments" {
  value = local.selected
}
