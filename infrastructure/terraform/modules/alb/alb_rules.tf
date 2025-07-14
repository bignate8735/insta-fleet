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