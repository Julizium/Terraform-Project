variable "vpc_id" {
  type        = string
  description = "The VPC ID that you wish to create the security groups in"
}

variable "allowed_ssh_ip" {
  type        = string
  description = "The allowed IP for SSH access"
  default     = "86.19.82.126/32"  
}