resource "aws_lb" "public_lb" {
  name               = "terraform-project-public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_security_groups
  subnets            = var.public_lb_subnets
}

resource "aws_lb" "private_lb" {
  name               = "terraform-project-private-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.lb_security_groups
  subnets            = var.private_lb_subnets
}


resource "aws_lb_listener" "public_lb_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}

resource "aws_lb_listener" "private_lb_listener" {
  load_balancer_arn = aws_lb.private_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}

resource "aws_lb_target_group" "lighting_target_group" {
  name        = "lighting-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "heating_target_group" {
  name        = "heating-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "status_target_group" {
  name        = "status-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "auth_target_group" {
  name        = "auth-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "lighting_attachment" {
  target_group_arn = aws_lb_target_group.lighting_target_group.arn
  target_id        = var.aws_instance_ids[1]
}

resource "aws_lb_target_group_attachment" "heating_attachment" {
  target_group_arn = aws_lb_target_group.heating_target_group.arn
  target_id        = var.aws_instance_ids[0]
}

resource "aws_lb_target_group_attachment" "status_attachment" {
  target_group_arn = aws_lb_target_group.status_target_group.arn
  target_id        = var.aws_instance_ids[2]
}

resource "aws_lb_target_group_attachment" "auth_attachment" {
  target_group_arn = aws_lb_target_group.auth_target_group.arn
  target_id        = var.aws_instance_ids[3]
}


# rules: 

resource "aws_lb_listener_rule" "public_lb_routing_lighting" {
  listener_arn = aws_lb_listener.public_lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lighting_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/lighting"]
    }
  }
}

resource "aws_lb_listener_rule" "public_lb_routing_heating" {
  listener_arn = aws_lb_listener.public_lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.heating_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/heating"]
    }
  }
}

resource "aws_lb_listener_rule" "public_lb_routing_status" {
  listener_arn = aws_lb_listener.public_lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.status_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/status"]
    }
  }
}

resource "aws_lb_listener_rule" "private_lb_routing_auth" {
  listener_arn = aws_lb_listener.private_lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/auth/status"]
    }
  }
}
