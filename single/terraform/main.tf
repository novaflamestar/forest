module "cowsay_lambda" {
  source = "../../module/python_lambda"
  source_dir = "../src"
  source_filename = "main.py"
  function_name = "cowsay_lambda"
}