resource "aws_security_group" "qa_ec2" {
  vpc_id      = var.vpc_id
  name        = "qa_ec2"
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

resource "aws_security_group_rule" "allow_qa_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = var.rds_sg_id     # <- target SG (RDS)
  source_security_group_id = aws_security_group.qa_ec2.id  # <- source SG (bastion)
  description              = "Allow QA EC2 access to RDS"
}
