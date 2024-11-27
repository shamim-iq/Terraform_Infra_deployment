#EC2
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "proj-instance" {
  for_each        = aws_subnet.proj_public
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = each.value.id
  security_groups = [aws_security_group.proj-Sg.id]
  iam_instance_profile = aws_iam_instance_profile.proj_instance_profile.name
  user_data = base64encode(file("user_data${replace(each.key, "subnet", "")}.sh"))

}

#Security Group
resource "aws_security_group" "proj-Sg" {
  name   = "proj-Sg"
  vpc_id = aws_vpc.proj-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_cidr_blocks
  }
}
