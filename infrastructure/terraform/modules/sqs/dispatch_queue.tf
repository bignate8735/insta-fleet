resource "aws_sqs_queue" "dispatch" {
  name                      = "${var.project}-dispatch-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dispatch_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Environment = var.env
  }
}

resource "aws_sqs_queue" "dispatch_dlq" {
  name = "${var.project}-dispatch-dlq"
}