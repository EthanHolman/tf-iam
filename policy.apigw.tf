resource "aws_iam_policy" "apigw_policy" {
  name        = "${local.name_prefix}apigw"
  path        = "/"
  description = "Allow apps to perform runtime operations on api gateway"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "execute-api:ManageConnections",
        ],
        "Resource" : [
          "arn:aws:execute-api:*:*:*/*"
        ]
      }
    ]
  })
}
