variable "function_name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "source_code" {
  type = string
}

variable "handler_function" {
  type    = string
  default = "main_handler"
}

variable "log_format" {
  type    = string
  default = "Text"
}

variable "custom_policies" {
  type        = map(string)
  description = "Map of policy names and policy strings"
  default     = {}
}

variable "environment" {
  type        = map(string)
  description = "Map of Lambda environment"
  default     = {}
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "timeout" {
  type    = number
  default = 30
}

variable "reserved_concurrent_executions" {
  type    = number
  default = 2
}

variable "runtime" {
  type    = string
  default = "python3.9"
}

variable "publish" {
  type    = bool
  default = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources"
  default     = null
}
