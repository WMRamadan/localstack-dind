variable "env" {
  type = string
}

variable "availability_zone" {
  type = string
}

# CIDR block for the VPC
variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

# List of CIDR blocks for public subnets
variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

# List of CIDR blocks for private subnets
variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "aws_region" {
  type = string
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "tags" {
  type = map(string)
}
