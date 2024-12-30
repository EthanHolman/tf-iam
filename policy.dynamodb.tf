resource "aws_iam_policy" "dynamodb_policy" {
  name        = "${local.name_prefix}dynamodb"
  path        = "/"
  description = "Allow apps to use dynamodb"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:ListTables",
          "dynamodb:DeleteItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem",
          "dynamodb:BatchGetItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:DescribeGlobalTable",
          "dynamodb:GetRecords",
          "dynamodb:Query",
          "dynamodb:Scan",
        ],
        "Resource" : [
          "arn:aws:dynamodb:*:*:table/*-${var.apps_prefix}-*"
        ]
      }
    ]
  })
}
