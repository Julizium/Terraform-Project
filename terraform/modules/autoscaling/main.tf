
# AMI created via console

resource "aws_launch_template" "launch_template" {
  name = var.template_name

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  network_interfaces {
   associate_public_ip_address = true
   security_groups  = var.security_group_ids
  }

  instance_type = "t2.micro"
  key_name      = "UYScutiKey"
  image_id = var.image_id

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ExampleInstance"
    }
  }
}

# ASG:

resource "aws_autoscaling_group" "asg" {
  name                 = var.asg_name
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  health_check_type          = "EC2"
  desired_capacity           = 2
  min_size                   = 1
  max_size                   = 2
  force_delete                = true

    tag {
    key                 = "name"
    value               = "example-instance"
    propagate_at_launch = true
  }
    lifecycle {
    create_before_destroy = true
  }


  target_group_arns = [var.target_group_arn]
}


