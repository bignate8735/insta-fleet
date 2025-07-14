data "aws_iam_policy_document" "ecs_secrets_access" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [aws_secretsmanager_secret.db_credentials.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "ecs_secrets_access" {
  name   = "${var.project}-ecs-secrets-policy"
  policy = data.aws_iam_policy_document.ecs_secrets_access.json
}

resource "aws_iam_role_policy_attachment" "ecs_secrets_attach" {
  role       = var.ecs_task_role_name
  policy_arn = aws_iam_policy.ecs_secrets_access.arn
}