resource "aws_iam_policy" "ecs_sqs_policy" {
  name = "${var.project}-ecs-sqs-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes"
        ],
        Resource = [
          var.dispatch_queue_arn,
          var.notification_queue_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_sqs_attachment" {
  role       = var.ecs_task_role_name
  policy_arn = aws_iam_policy.ecs_sqs_policy.arn
}