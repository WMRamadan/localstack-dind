output "api" {
  value = "curl http://localstack:4566/restapis/${aws_api_gateway_rest_api.webserver-api.id}/test/_user_request_/ -vv"
}

output "s3_file_url" {
  value = "curl http://localstack:4566/${aws_s3_bucket.file_bucket.bucket}/${aws_s3_object.data_file.key} -vv"
}

output "instance_id" {
  value = aws_instance.example.id
}

output "vpc_id" {
  value = aws_vpc.example.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}
