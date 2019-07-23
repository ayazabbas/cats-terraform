data "aws_iam_policy_document" "streetbees_deployment_trust_relationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com", "lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "streetbees_step_functions_deployment_policy" {
  statement {
    actions = [
      "lambda:InvokeFunction",
      "tag:*",
      "iam:PassRole",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "streetbees_step_functions_deployment_policy" {
  name        = "streetbees-step-functions-deployment-policy"
  description = "Allows Step Functions to invoke Lambda"
  policy      = data.aws_iam_policy_document.streetbees_step_functions_deployment_policy.json
}

resource "aws_iam_role" "streetbees_deployment_role" {
  name               = "streetbees-deployment-role"
  description        = "Allows Step Functions and Lambda to deploy apps on Elastic Beanstalk."
  assume_role_policy = data.aws_iam_policy_document.streetbees_deployment_trust_relationship.json
}

resource "aws_iam_role_policy_attachment" "streetbees_ebs_policy_attachment" {
  role       = aws_iam_role.streetbees_deployment_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkFullAccess"
}

resource "aws_iam_role_policy_attachment" "streetbees_sfn_policy_attachment" {
  role       = aws_iam_role.streetbees_deployment_role.name
  policy_arn = aws_iam_policy.streetbees_step_functions_deployment_policy.arn
}
