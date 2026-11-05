resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    description = "Application port"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-sg" })
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-EOT
    #!/bin/bash
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
    yum install -y nodejs
  EOT

  tags = merge(var.tags, {
    Name        = var.name
    Environment = var.environment
  })
}
