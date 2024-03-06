variable "lb_security_groups" {
  type        = list(string)
}

variable "public_lb_subnets" {
  type        = list(string)
}

variable "private_lb_subnets" {
  type        = list(string)
}

variable "vpc_id" {
  type        = string
}

variable "aws_instance_ids" {
  type = list(string)
}