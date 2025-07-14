# ------------------------------
# alb.tf
# ------------------------------
resource "aws_lb" "this" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket  = var.alb_log_bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = {
    Name = "${var.project}-alb"
  }
}

# ------------------------------
# alb_listeners.tf
# ------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No matching route"
      status_code  = "404"
    }
  }
}

# ------------------------------
# alb_target_groups.tf
# ------------------------------
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
  target_type = "ip"

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

# ------------------------------
# alb_rules.tf
# ------------------------------
resource "aws_lb_listener_rule" "routes" {
  for_each     = local.services
  listener_arn = aws_lb_listener.https.arn
  priority     = 100 + index(keys(local.services), each.key)

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

# ------------------------------
# alb_outputs.tf
# ------------------------------
output "alb_dns_name" {
  description = "Public DNS of the ALB"
  value       = aws_lb.this.dns_name
}

output "target_group_arns" {
  description = "Map of service to Target Group ARNs"
  value = {
    for service, tg in aws_lb_target_group.services :
    service => tg.arn
  }
}

# ------------------------------
# alb_variables.tf
# ------------------------------
variable "project" {
  description = "Project name (used in naming resources)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ALB target groups"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}

variable "ssl_certificate_arn" {
  description = "ACM SSL certificate ARN for HTTPS"
  type        = string
}

variable "alb_log_bucket" {
  description = "S3 bucket name for storing ALB logs"
  type        = string
}