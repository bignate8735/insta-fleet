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