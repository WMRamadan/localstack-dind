variable "bucket" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "tags" {
  type        = map(string)
  default     = null
}

variable "policies" {
  type        = map(any)
  default     = {}
  description = "Custom IAM policies"
}

variable "encryption_configuration" {
  type = object({
    enabled       = bool
    sse_algorithm = string
  })
  default = {
    enabled       = true
    sse_algorithm = "AES256"
  }
  description = "Encryption configuration"
}

variable "versioning_configuration" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = true
  }
  description = "Versioning configuration"
}

variable "public_access_block" {
  type = object({
    acls    = bool
    policy  = bool
    acls    = bool
    buckets = bool
  })
  default = {
    acls    = true
    policy  = true
    acls    = true
    buckets = true
  }
}
