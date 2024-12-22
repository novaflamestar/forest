module "cowsay_lambda" {
  source = "../../module/python_lambda"
  source_dir = "../src/cowsay"
  source_filename = "main.py"
  function_name = "cowsay_multi_lambda"
}

module "tuxsay_lambda" {
  source = "../../module/python_lambda"
  source_dir = "../src/tuxsay"
  source_filename = "main.py"
  function_name = "tuxsay_multi_lambda"
}
