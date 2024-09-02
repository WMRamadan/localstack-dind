output "function_arn" {
  value = aws_lambda_function.py_lambda_function.arn
}

output "function_name" {
  value = aws_lambda_function.py_lambda_function.function_name
}

output "function_handler" {
  value = aws_lambda_function.py_lambda_function.handler
}

output "role_arn" {
  value = aws_iam_role.exec_role.arn
}

output "invoke_arn" {
  value = aws_lambda_function.py_lambda_function.invoke_arn
}
