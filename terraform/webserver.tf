locals {
  webserver_function_name = "${var.team}-${var.product}-webserver"
}

data "local_file" "source_webserver" {
  filename = "${path.module}/source/main.py"
}

module "webserver_lambda" {
  source        = "./modules/terraform-aws-lambda-py"
  function_name = local.webserver_function_name
  description   = "Web server"
  source_code   = data.local_file.source_webserver.content
  tags          = var.tags
}
