output "api" {
  value = "curl http://localstack:4566/restapis/${aws_api_gateway_rest_api.webserver-api.id}/test/_user_request_/ -vv"
}

output "s3_file_url" {
  value = "curl http://localstack:4566/${aws_s3_bucket.file_bucket.bucket}/${aws_s3_object.data_file.key} -vv"
}
