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

data "http" "me" {
  url             = "${var.base_url}/accounts/api/me"
  request_headers = local.request_headers
}

locals {
  me               = jsondecode(data.http.me.response_body)
  organization     = try(local.me.user.organization, local.me.organization, {})
  business_groups  = try(local.organization.subOrganizations, [])
}

output "identity" {
  value = {
    username          = try(local.me.user.username, local.me.username, null)
    organization_id   = try(local.organization.id, null)
    organization_name = try(local.organization.name, null)
    business_groups   = [for group in local.business_groups : { id = group.id, name = group.name }]
  }
}
