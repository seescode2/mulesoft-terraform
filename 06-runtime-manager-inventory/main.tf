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
variable "environment_id" {
  type = string
}
variable "include_hybrid_servers" {
  type    = bool
  default = false
}

data "http" "applications" {
  url = "${var.base_url}/cloudhub/api/v2/applications"
  request_headers = merge(local.request_headers, {
    "X-ANYPNT-ORG-ID" = var.organization_id
    "X-ANYPNT-ENV-ID" = var.environment_id
  })
}
data "http" "hybrid_servers" {
  count = var.include_hybrid_servers ? 1 : 0
  url   = "${var.base_url}/hybrid/api/v1/servers"
  request_headers = merge(local.request_headers, {
    "X-ANYPNT-ORG-ID" = var.organization_id
    "X-ANYPNT-ENV-ID" = var.environment_id
  })
}
locals {
  app_payload = jsondecode(data.http.applications.response_body)
  applications = [for app in try(local.app_payload.data, local.app_payload, []) : {
    name   = try(app.domain, app.name, null)
    status = try(app.status, null)
    region = try(app.region, null)
  }]
  hybrid_servers = var.include_hybrid_servers ? try(jsondecode(data.http.hybrid_servers[0].response_body).data, jsondecode(data.http.hybrid_servers[0].response_body), []) : []
}
output "applications" {
  value = local.applications
}
output "hybrid_server_count" {
  value = length(local.hybrid_servers)
}
