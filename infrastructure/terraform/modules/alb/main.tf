# ------------------------------------------------------------------------------
# Application Load Balancer (public-facing)
# ------------------------------------------------------------------------------

resource "aws_lb" "this" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project}-alb"
  }
}

# ------------------------------------------------------------------------------
# HTTP Listener on port 80 (default listener)
# ------------------------------------------------------------------------------

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  # Fallback fixed response if no rule matches
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No matching route"
      status_code  = "404"
    }
  }
}

# ------------------------------------------------------------------------------
# Define Target Groups per service
# ------------------------------------------------------------------------------

locals {
  services = {
    auth         = 3000
    booking      = 3001
    driver       = 3002
    dispatch     = 3003
    notification = 3004
  }
}

resource "aws_lb_target_group" "services" {
  for_each    = local.services
  name        = "${var.project}-tg-${each.key}"
  port        = each.value
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Required for Fargate

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.project}-tg-${each.key}"
  }
}

# ------------------------------------------------------------------------------
# Listener Rules for routing to each service
# ------------------------------------------------------------------------------

resource "aws_lb_listener_rule" "routes" {
  for_each     = local.services
  listener_arn = aws_lb_listener.http.arn
  priority     = 100 + index(keys(local.services), each.key) # e.g. 100, 101, ...

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services[each.key].arn
  }

  condition {
    path_pattern {
      values = ["/${each.key}*", "/${each.key}/*"]
    }
  }
}