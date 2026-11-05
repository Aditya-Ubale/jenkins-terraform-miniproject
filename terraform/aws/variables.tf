variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID (replace with a valid Amazon Linux AMI for the region before a real apply)"
  type        = string
  default     = "ami-0123456789abcdef0"
}

variable "ssh_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "offline_validation" {
  description = "Skip AWS credential and account checks so plan works without an AWS account"
  type        = bool
  default     = false
}
