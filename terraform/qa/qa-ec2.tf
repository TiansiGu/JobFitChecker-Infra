data "aws_ami" "ec2_image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name = "name"
    values = ["AL2_x86_64-with-Docker*"] // custom AMI with docker and ssh key set up
  }
}

resource "aws_instance" "ec2" {
  count         = 1
  ami           = data.aws_ami.ec2_image.id
  instance_type = "t3.medium"
  subnet_id = var.public_subnet_ids[0]
  key_name      = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.qa_ec2.id]
  tags = {
    Name = "qa"
  }
}