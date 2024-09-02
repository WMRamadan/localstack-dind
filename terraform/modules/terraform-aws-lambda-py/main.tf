locals {
  py_file_name = "py_rendered_file"
  handler        = "${local.py_file_name}.${var.handler_function}"
}

resource "aws_lambda_function" "py_lambda_function" {
  function_name                  = var.function_name
  filename                       = data.archive_file.py_zipped_file.output_path
  source_code_hash               = data.archive_file.py_zipped_file.output_base64sha256
  description                    = var.description
  role                           = aws_iam_role.exec_role.arn
  handler                        = local.handler
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  publish                        = var.publish

  environment {
    variables = var.environment
  }

  tags = merge(var.tags, {
    Name = var.function_name
  })


  lifecycle {
    ignore_changes = [
      # always auto-published by lambda
      qualified_arn,
      qualified_invoke_arn
    ]
  }
}
