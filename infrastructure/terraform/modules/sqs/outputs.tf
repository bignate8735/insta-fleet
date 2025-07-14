output "dispatch_queue_url" {
  value = aws_sqs_queue.dispatch.id
}

output "dispatch_queue_arn" {
  value = aws_sqs_queue.dispatch.arn
}

output "notification_queue_url" {
  value = aws_sqs_queue.notification.id
}

output "notification_queue_arn" {
  value = aws_sqs_queue.notification.arn
}