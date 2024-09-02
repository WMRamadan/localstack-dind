output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket
}

output "arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "id" {
  value = aws_s3_bucket.s3_bucket.id
}
