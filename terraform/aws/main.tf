provider "aws" {
  region = var.aws_region

  skip_credentials_validation = var.offline_validation
  skip_requesting_account_id  = var.offline_validation
  skip_metadata_api_check     = var.offline_validation
  skip_region_validation      = var.offline_validation
}

module "web_server" {
  source = "../modules/web_server"

  name          = "inventory-${var.environment}"
  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = var.instance_type
  ssh_cidr      = var.ssh_cidr
  app_port      = 3000

  tags = {
    Owner   = "Aditya Ubale"
    PRN     = "202301040111"
    Project = "Jenkins-Terraform-MiniProject"
  }
}
