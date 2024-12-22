data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.function_name}_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type = "zip"
  source_file = "${var.source_dir}/${var.source_filename}"
  output_path = "${var.function_name}.zip"
}

resource "aws_lambda_function" "test_lambda" {
    filename = "${var.function_name}.zip"
    function_name = var.function_name
    role = aws_iam_role.iam_for_lambda.arn
    handler = "main.lambda_handler"
    source_code_hash = data.archive_file.lambda.output_base64sha256
    layers = [ aws_lambda_layer_version.lambda_layer.arn ]
    runtime = "python3.11"
}

data "archive_file" "layer" {
  type = "zip"
  source_dir = "${var.source_dir}/layer"
  output_path = "${var.function_name}_layer.zip"
  depends_on = [ 
    resource.terraform_data.pipenv_install
  ]
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename = "${var.function_name}_layer.zip"
  layer_name = "${var.function_name}_layer"
  source_code_hash = data.archive_file.layer.output_md5 
  compatible_runtimes = ["python3.11"]
  depends_on = [ 
    data.archive_file.layer
  ]
}
