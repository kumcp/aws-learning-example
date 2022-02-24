resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(
    local.common_tags,
    tomap({
      "Name"        = "${lower(var.environment)}-vpc",
      "Description" = "VPC"
    })
  )
}
