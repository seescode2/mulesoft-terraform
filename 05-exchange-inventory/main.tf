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
variable "limit" {
  type    = number
  default = 20
}

data "http" "assets" {
  url = "${var.base_url}/exchange/api/v2/assets?organizationId=${urlencode(var.organization_id)}&limit=${var.limit}"
  request_headers = merge(local.request_headers, { "X-ANYPNT-ORG-ID" = var.organization_id })
}
locals {
  payload = jsondecode(data.http.assets.response_body)
  assets = [for asset in try(local.payload, []) : {
    group_id = try(asset.groupId, null)
    asset_id = try(asset.assetId, null)
    version  = try(asset.version, null)
    type     = try(asset.type, null)
  }]
}
output "assets" {
  value = local.assets
}
