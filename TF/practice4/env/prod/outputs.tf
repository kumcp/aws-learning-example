output "instance_id" {
  value = module.public_ec2.instance_id
}


output "lb_cname" {
  value = module.alb.lb_dns_name
}
