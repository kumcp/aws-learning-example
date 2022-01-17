variable "instance_name" {
  description = "ec2 instance name tag"
  type        = string
  default     = "instance created by tf"
}

variable "bootstrap_script" {
  description = "bootstrap script"
  type        = string
  default     = ""
}
