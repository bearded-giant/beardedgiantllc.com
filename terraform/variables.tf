variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-east1"
}

variable "sites" {
  description = "site domain to local build path mapping"
  type = map(object({
    domain = string
  }))
  default = {
    llc = { domain = "beardedgiantllc.com" }
    bbq = { domain = "beardedgiantbbq.com" }
    ai  = { domain = "beardedgiant.ai" }
  }
}
