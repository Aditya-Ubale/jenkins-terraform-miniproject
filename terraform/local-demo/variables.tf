variable "environment" {
  description = "Target environment name"
  type        = string
  default     = "staging"
}

variable "app_port" {
  description = "Port the application will listen on"
  type        = number
  default     = 3100
}

variable "build_number" {
  description = "CI build number being deployed"
  type        = string
  default     = "0"
}

variable "deploy_root" {
  description = "Directory that represents the target environment"
  type        = string
  default     = "./deploy/staging"
}
