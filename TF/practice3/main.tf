resource "aws_iam_user" "users" {
  count = length(var.usernames)
  name  = var.user_names[count.index]
}

#  Access 1 item
output "main_public_ip" {
  value       = ec2_fleet.instance[0].public_ip
}

#  Access multi items
output "all_public_ip" {
  value       = ec2_fleet.instance[*].public_ip
}

output "all_public_ip2" {
  value       = [for i in ec2_fleet.instance : i.public_ip]  
}


variable "tags" {
  description = "Custom tagsG"
  type        = map(string)
  default = {
    "name" = "codestar-do"
    "project" = "prod"
  }
}

resource "aws_autoscaling_group" "asg" {

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}