variable "name" {
  description = "Name prefix for the resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 3000
}

variable "tags" {
  description = "Extra tags applied to all resources"
  type        = map(string)
  default     = {}
}
