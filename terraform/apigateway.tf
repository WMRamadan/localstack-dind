# Defines the API Gateway REST API for the Lambda function
resource "aws_api_gateway_rest_api" "webserver-api" {
  name        = "WebserverApi"
  description = "API to call Lambda"
}

# Creates a resource with a proxy path that allows dynamic routing (e.g., for Lambda integration)
resource "aws_api_gateway_resource" "webserver-resource" {
  rest_api_id = aws_api_gateway_rest_api.webserver-api.id
  parent_id   = aws_api_gateway_rest_api.webserver-api.root_resource_id
  path_part   = "{proxy+}"
}

# Defines the HTTP method (ANY) for the API Gateway resource and disables authorization
resource "aws_api_gateway_method" "webserver-method" {
  rest_api_id   = aws_api_gateway_rest_api.webserver-api.id
  resource_id   = aws_api_gateway_resource.webserver-resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integrates the API Gateway with an AWS Lambda function using AWS_PROXY (Lambda proxy integration)
resource "aws_api_gateway_integration" "webserver-integration" {
  rest_api_id             = aws_api_gateway_rest_api.webserver-api.id
  resource_id             = aws_api_gateway_resource.webserver-resource.id
  http_method             = aws_api_gateway_method.webserver-method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.webserver_lambda.invoke_arn
}

# Defines the root (/) method for the API Gateway, accepting any HTTP method (ANY)
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.webserver-api.id
  resource_id   = aws_api_gateway_rest_api.webserver-api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integrates the root (/) method with an AWS Lambda function using AWS_PROXY
resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.webserver-api.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.webserver_lambda.invoke_arn
}

# Deploys the API Gateway to a specific stage ("api") after all integrations are set up
resource "aws_api_gateway_deployment" "webserver-deployment" {
  rest_api_id = aws_api_gateway_rest_api.webserver-api.id
  depends_on = [
    aws_api_gateway_integration.webserver-integration,
    aws_api_gateway_integration.lambda_root
  ]
  stage_name = "api"
}

# Grants API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.webserver_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.webserver-api.execution_arn}/*/*/*"
}
