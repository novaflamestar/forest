data "local_file" "pipenv" {
  filename = "${var.source_dir}/Pipfile"
}

data "local_file" "pipenv_lock" {
  filename = "${var.source_dir}/Pipfile.lock"
  depends_on = [ resource.terraform_data.pipenv_update ]
}

resource "terraform_data" "pipenv_update" {
    provisioner "local-exec" {
      command = <<EOT
        pipenv install
      EOT
      working_dir = var.source_dir
    }
  triggers_replace = [
    data.local_file.pipenv.content_md5
  ]
}

resource "terraform_data" "pipenv_install" {
    provisioner "local-exec" {
      command = <<EOT
        pipenv requirements > requirements.txt
        pipenv run pip install -r requirements.txt --target layer/python/lib/python3.11/site-packages/ --upgrade
      EOT
      working_dir = var.source_dir
    }
    triggers_replace = [
      resource.terraform_data.pipenv_update.id,
    ]
    depends_on = [ terraform_data.pipenv_update ]
}