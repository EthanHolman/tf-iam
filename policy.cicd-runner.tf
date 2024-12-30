resource "aws_iam_policy" "cicd_runner_policy" {
  name        = "${local.name_prefix}cicd-runner"
  path        = "/"
  description = "Perms for cicd runner to manage infrastructure"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ManageTerraformStateBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
        ],
        "Resource" : "arn:aws:s3:::${var.tf_state_bucket}"
      },
      {
        "Sid" : "ManageTerraformState",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : "arn:aws:s3:::${var.tf_state_bucket}/*"
      },
      {
        "Sid" : "TerraformStateLockDynamo",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/${var.tf_dynamo_state_table}"
      },
      {
        "Sid" : "ManageAppDynamo",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:*"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:*-app-*"
      },
      {
        "Sid" : "ManageAppIAMRoles",
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateRole",
          "iam:GetRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:UpdateAssumeRolePolicy"
        ],
        "Resource" : "arn:aws:iam::${var.aws_acct_number}:role/*-app-*"
      },
      {
        "Sid" : "ReadAppIAMPolicies",
        "Effect" : "Allow",
        "Action" : [
          "iam:GetPolicy",
          "iam:GetPolicyVersion"
        ],
        "Resource" : "arn:aws:iam::${var.aws_acct_number}:policy/app-*"
      },
      {
        "Sid" : "ManageAppLambdas",
        "Effect" : "Allow",
        "Action" : [
          "lambda:GetFunction",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:DeleteFunctionCodeSigningConfig",
          "lambda:UpdateFunctionCodeSigningConfig",
          "lambda:ListFunctions",
          "lambda:ListVersionsByFunction",
          "lambda:UpdateFunctionConfiguration",
          "lambda:GetFunctionConfiguration",
          "lambda:GetFunctionCodeSigningConfig",
          "lambda:UpdateFunctionCode",
          "lambda:GetFunctionConcurrency",
          "lambda:PublishVersion",
          "lambda:PutFunctionCodeSigningConfig",
          "lambda:ListTags",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy",
          "lambda:ListLayers",
          "lambda:ListLayerVersions",
          "lambda:GetLayerVersion",
          "lambda:PublishLayerVersion",
          "lambda:DeleteLayerVersion",
          "lambda:AddLayer"
        ],
        "Resource" : "arn:aws:lambda:*:*:*-app-*"
      },
      {
        "Sid" : "Cloudwatch",
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogGroups",
          "logs:ListTagsLogGroup"
        ],
        "Resource" : "arn:aws:logs:us-west-2:${var.aws_acct_number}:log-group:*:log-stream:*"
      },
      {
        "Sid" : "AppCloudwatch"
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:TagResource",
          "logs:UntagResource",
          "logs:TagLogGroup",
          "logs:UntagLogGroup",
          "logs:CreateLogStream",
          "logs:DeleteLogStream",
          "logs:PutRetentionPolicy",
          "logs:DeleteRetentionPolicy"
        ],
        "Resource" : "arn:aws:logs:us-west-2:${var.aws_acct_number}:*-${var.apps_prefix}-*"
      },
      {
        "Sid" : "AppApiGateway",
        "Effect" : "Allow",
        "Action" : [
          "apigateway:*"
        ],
        "Resource" : "arn:aws:apigateway:us-west-2::*"
      },
      {
        "Sid" : "AppAllowPassRole",
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole"
        ],
        "Resource" : "arn:aws:iam::${var.aws_acct_number}:role/*-app-*",
        "Condition" : {
          "StringLike" : {
            "iam:PassedToService" : [
              "ec2.amazonaws.com",
              "lambda.amazonaws.com",
              "apigateway.amazonaws.com"
            ]
          }
        }
      },
    ]
  })
}
