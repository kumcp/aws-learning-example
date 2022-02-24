######## IGW ###############
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "IGW"
    })
  )
}

########### NAT ##############
resource "aws_eip" "nat_ip" {
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_nets[0].id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "NatGateway",
    })
  )
}

############# Route Tables ##########

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "public-rtb",
    })
  )

}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-natgw.id
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "private-rtb",
    })
  )
}

# Route table association

resource "aws_route_table_association" "route_Publicsubnet" {
  subnet_id      = element(aws_subnet.public_nets.*.id, count.index)
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "route_Privatesubnet" {
  subnet_id      = element(aws_subnet.private_nets.*.id, count.index)
  count          = length(var.private_subnets)
  route_table_id = aws_route_table.PrivateRouteTable.id
}
