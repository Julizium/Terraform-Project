output "target_groups_arn" {
  value = [
  aws_lb_target_group.lighting_target_group.arn, 
  aws_lb_target_group.status_target_group.arn, 
  aws_lb_target_group.auth_target_group.arn, 
  aws_lb_target_group.heating_target_group.arn, 
  ]
}