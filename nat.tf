#### NAT Gateway configuration

#### Defining Elastic IP address for a NAT-Gateway
resource "aws_eip" "elastic_ip_for_NAT" {
  vpc = true
}

resource "aws_nat_gateway" "gwNAT" {
  allocation_id = aws_eip.elastic_ip_for_NAT.id
  subnet_id     = element(aws_subnet.subnet-public.*.id, 0)
  depends_on    = [aws_internet_gateway.gw]

  tags = {
    Name = "gw-NAT"
  }
}

#### Route Table rule for Private Subnet NAT

resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.bastion.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gwNAT.id
  }

  tags = {
    Name = "Private-RT-NAT"
  }
}
