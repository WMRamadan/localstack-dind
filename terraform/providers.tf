provider "aws" {
  region                      = var.aws_region
  access_key                  = "myrootaccesskeyid"
  secret_key                  = "myrootsecretaccesskey"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
  s3_use_path_style           = true # Important to add for Terraform AWS provider

  endpoints {
    apigateway     = "http://localstack:4566"
    iam            = "http://localstack:4566"
    lambda         = "http://localstack:4566"
    s3             = "http://localstack:4566"
    ec2            = "http://localstack:4566"
  }

  default_tags {
    tags = merge(var.tags, {
      Environment = var.env
    })
  }
}
