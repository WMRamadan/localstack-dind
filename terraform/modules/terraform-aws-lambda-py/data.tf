data "archive_file" "py_zipped_file" {
  type        = "zip"
  output_path = "${path.module}/${local.py_file_name}.zip"

  source {
    content  = var.source_code
    filename = "${local.py_file_name}.py"
  }
}
