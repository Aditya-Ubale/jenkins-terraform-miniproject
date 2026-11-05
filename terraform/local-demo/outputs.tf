output "deploy_dir" {
  description = "Directory of the provisioned environment"
  value       = var.deploy_root
}

output "release_id" {
  description = "Generated release identifier"
  value       = random_id.release.hex
}

output "app_port" {
  description = "Application port"
  value       = var.app_port
}
