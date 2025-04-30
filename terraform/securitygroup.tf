resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.vpc_id
  name        = "allow-ssh"
  description = "security group for bastion that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // allow all outbound protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22  // allow ssh
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}