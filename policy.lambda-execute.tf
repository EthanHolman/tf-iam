resource "aws_iam_policy" "lambda_execute_policy" {
  name        = "${local.name_prefix}lambda-execute"
  path        = "/"
  description = "Permissions given to lambda functions during execution"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" = [
          "ec2:Describe*",
        ]
        "Effect"   = "Allow"
        "Resource" = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-2:${var.aws_acct_number}:log-group:/aws/lambda/*-${var.apps_prefix}-*:*"
        ]
      }
    ]
  })
}
