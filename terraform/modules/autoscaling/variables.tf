

variable "security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs to apply to the instances"
}

variable "asg_name" {
  type        = string
}

variable "target_group_arn" {
  type        = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "image_id" {
    type = string
}

variable "template_name" {
    type = string
}