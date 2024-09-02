locals {
  exec_role_name = "${var.function_name}-exec-role"
}

resource "aws_iam_role" "exec_role" {
  name               = local.exec_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(var.tags, {
    Name = local.exec_role_name
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "custom_policies" {
  for_each = var.custom_policies
  name     = each.key
  policy   = each.value
  role     = aws_iam_role.exec_role.name
}
