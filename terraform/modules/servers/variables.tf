variable "public_subnets" {
  type        = list(string)
}

variable "security_group_ids" {
  type        = list(string)
}

variable "ami" {
  type = string
}

variable "private_subnets" {
  type        = list(string)
}