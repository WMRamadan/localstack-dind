resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket
  force_destroy = var.force_destroy
  tags = merge(var.tags, {
    Name = var.bucket
  })
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning_configuration.enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = var.public_access_block.acls
  block_public_policy     = var.public_access_block.policy
  ignore_public_acls      = var.public_access_block.acls
  restrict_public_buckets = var.public_access_block.buckets
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  count  = var.encryption_configuration.enabled == true ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_configuration.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = length(var.policies)
  bucket = aws_s3_bucket.s3_bucket.id
  policy = var.policies[count.index]
}
