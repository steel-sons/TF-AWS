# Setup AWS VPC

resource "aws_vpc" "bastion" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    "Name"                                      = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#### Create VPC subnets #################

#### Public Subnet
resource "aws_subnet" "subnet-public" {
  count = length(var.availability_zones) // count the number of availability_zones variable

  vpc_id                  = aws_vpc.bastion.id
  cidr_block              = cidrsubnet(aws_vpc.bastion.cidr_block, 8, length(var.availability_zones) + count.index + 1)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = "true" //this makes it a public subnet

  tags = {
    "Name"                                      = "Public-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "kubernetes.io/role/elb"                    = 1
  }
}

#### Public Route Table assossiation RT-AS
resource "aws_route_table_association" "public-RT-AS" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.subnet-public.*.id, count.index)
  route_table_id = aws_route_table.public-RT.id
}

#### Private Subnet
resource "aws_subnet" "subnet-private" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.bastion.id
  cidr_block              = cidrsubnet(aws_vpc.bastion.cidr_block, 8, length(var.availability_zones) + count.index + 4)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = "false" //this make it a private subnet

  tags = {
    "Name"                                      = "Private-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "kubernetes.io/role/internal-elb"           = 1
  }
}

#### Private Route Table assosiation RT-AS
resource "aws_route_table_association" "private-RT-AS" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.subnet-private.*.id, count.index)
  route_table_id = aws_route_table.private-RT.id
}

#####################################
#### External network and Rout Tables
#####################################


#### Create main VPC IGW ################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.bastion.id

  tags = {
    Name = "main-IGW"
  }
  depends_on = [aws_vpc.bastion]
}

#### Route Table for a Public Subnet

resource "aws_route_table" "public-RT" {

  vpc_id = aws_vpc.bastion.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public RouteTable"
  }
  depends_on = [aws_subnet.subnet-public]
}
