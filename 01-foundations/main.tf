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

check "token_is_not_placeholder" {
  assert {
    condition     = length(var.access_token) > 20 && var.access_token != "replace-with-a-short-lived-token"
    error_message = "Supply a real short-lived token through TF_VAR_access_token or an ignored tfvars file."
  }
}

output "control_plane" {
  description = "The selected Anypoint control plane."
  value       = var.base_url
}
