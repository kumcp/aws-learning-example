data "aws_availability_zones" "available" {}


resource "aws_subnet" "private_nets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(split(",", join(",", var.private_subnets)), count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    tomap({
      "Name"        = "${lower(var.environment)}-private-${count.index + 1}",
      "Description" = "Private subnet - No. ${count.index + 1} for ${lower(var.environment)}"
    })
  )
}

resource "aws_subnet" "public_nets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(split(",", join(",", var.public_subnets)), count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    tomap({
      "Name"        = "${lower(var.environment)}-public-${count.index + 1}",
      "Description" = "Public subnet - No. ${count.index + 1} for ${lower(var.environment)}"
    })
  )

}
