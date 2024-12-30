resource "aws_iam_role" "cicd_runner_role" {
  name = "${local.name_prefix}cicd-runner-role"

  # forces removal of inline policies made in console upon apply
  inline_policy {}

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition : {
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:EthanHolman/bingo-app:*"
          }
          StringEquals : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
          }
        }

      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cicd_runner_policy_attach" {
  role       = aws_iam_role.cicd_runner_role.name
  policy_arn = aws_iam_policy.cicd_runner_policy.arn
}
