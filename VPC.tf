#VPC
resource "aws_vpc" "proj-vpc" {
  cidr_block = "10.0.0.0/16"
}

#public subnets
resource "aws_subnet" "proj_public" {
  for_each = {
    "subnet1" = { cidr = "10.0.1.0/24", az = "us-east-1a" }
    "subnet2" = { cidr = "10.0.2.0/24", az = "us-east-1b" }
  }

  vpc_id                  = aws_vpc.proj-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
}

#IGW
resource "aws_internet_gateway" "proj-igw" {
  vpc_id = aws_vpc.proj-vpc.id
}

#Route Table
resource "aws_route_table" "proj-rt" {
  vpc_id = aws_vpc.proj-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proj-igw.id
  }
}

#route table associations
resource "aws_route_table_association" "rta" {
  for_each       = aws_subnet.proj_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.proj-rt.id
}
