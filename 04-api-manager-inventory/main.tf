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

data "http" "api_instances" {
  url = "${var.base_url}/apimanager/api/v1/organizations/${var.organization_id}/environments/${var.environment_id}/apis"
  request_headers = merge(local.request_headers, {
    "X-ANYPNT-ORG-ID" = var.organization_id
    "X-ANYPNT-ENV-ID" = var.environment_id
  })
}
locals {
  api_payload = jsondecode(data.http.api_instances.response_body)
  api_instances = [for api in try(local.api_payload.assets, local.api_payload.data, []) : {
    id       = try(api.id, null)
    name     = try(api.assetId, api.name, null)
    version  = try(api.assetVersion, api.version, null)
    endpoint = try(api.endpointUri, api.endpoint.uri, null)
  }]
}
output "api_instances" {
  value = local.api_instances
}
