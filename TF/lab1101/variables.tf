variable "instance_name" {
  description = "ec2 instance name tag"
  type        = string
  default     = "instance created by tf"
}

variable "allow_ssh" {
  description = "IP allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}
