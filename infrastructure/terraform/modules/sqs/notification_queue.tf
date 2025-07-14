resource "aws_sqs_queue" "notification" {
  name = "${var.project}-notification-queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.notification_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Environment = var.env
  }
}

resource "aws_sqs_queue" "notification_dlq" {
  name = "${var.project}-notification-dlq"
}