resource "aws_s3_bucket" "code_star_tuyetvoi" {
  count = 3
  bucket = replace("code.star.tuyetvoi.${count.index}", ".", "-")
  acl = "public-read"
  lifecycle {
    create_before_destroy = true
    prevent_destroy = true
    ignore_changes = [ "acl" ]
  }
}

provider "aws" {
    region = "ap-southeast-1"
    profile = "hungran"
}