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
  type = string
}

data "http" "users" {
  url = "${var.base_url}/accounts/api/organizations/${var.organization_id}/users"
  request_headers = merge(local.request_headers, { "X-ANYPNT-ORG-ID" = var.organization_id })
}
locals {
  user_payload = jsondecode(data.http.users.response_body)
  users = [for user in try(local.user_payload.data, local.user_payload, []) : {
    id       = try(user.id, null)
    username = try(user.username, null)
    enabled  = try(user.enabled, null)
  }]
}
output "access_review" {
  value = {
    total_users    = length(local.users)
    disabled_users = [for user in local.users : user.username if user.enabled == false]
  }
}
