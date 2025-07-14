# ------------------------------------------------------------------------------
# Inline IAM Policy - allows ECS tasks access to S3 & DynamoDB
# ------------------------------------------------------------------------------

resource "aws_iam_policy" "app_policy" {
  name        = "${var.project}-ecs-app-policy"
  description = "Policy to allow S3 and DynamoDB access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = "arn:aws:s3:::${var.project}-bucket/*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}