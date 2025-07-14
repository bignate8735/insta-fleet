resource "aws_security_group" "ssh_sg" {
  name        = "${var.project}-ssh-sg"
  description = "Allow SSH access from trusted IPs"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-ssh-sg"
  }
}