# Provisions a deployment environment on the local machine.
# It uses the same Terraform workflow (init, plan, apply, destroy) as cloud resources.

resource "random_id" "release" {
  byte_length = 4
}

resource "local_file" "env_config" {
  filename        = "${var.deploy_root}/app.env"
  file_permission = "0644"
  content         = <<-EOT
    PORT=${var.app_port}
    APP_ENV=${var.environment}
    RELEASE_ID=${random_id.release.hex}
    BUILD_NUMBER=${var.build_number}
  EOT
}

resource "local_file" "manifest" {
  filename = "${var.deploy_root}/release.json"
  content = jsonencode({
    application = "inventory-api"
    environment = var.environment
    release_id  = random_id.release.hex
    build       = var.build_number
    owner       = "Aditya Ubale"
    prn         = "202301040111"
  })
}

resource "terraform_data" "announce" {
  triggers_replace = [random_id.release.hex, var.build_number]

  provisioner "local-exec" {
    command = "echo Provisioned ${var.environment} environment, release ${random_id.release.hex}"
  }
}
