data "archive_file" "lambda_evaluate_ebs_application_versions" {
  type        = "zip"
  source_file = "files/lambda/evaluate_ebs_application_versions.py"
  output_path = "tmp/evaluate_ebs_application_versions.zip"
}

resource "aws_lambda_function" "lambda_evaluate_ebs_application_versions" {
  function_name    = "streetbees-evaluate-ebs-application-versions"
  filename         = data.archive_file.lambda_evaluate_ebs_application_versions.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "evaluate_ebs_application_versions.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_evaluate_ebs_application_versions.output_path)
}

data "archive_file" "lambda_create_ebs_application_version" {
  type        = "zip"
  source_file = "files/lambda/create_ebs_application_version.py"
  output_path = "tmp/create_ebs_application_version.zip"
}

resource "aws_lambda_function" "lambda_create_ebs_application_version" {
  function_name    = "streetbees-create-ebs-application-version"
  filename         = data.archive_file.lambda_create_ebs_application_version.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "create_ebs_application_version.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_create_ebs_application_version.output_path)
}

data "archive_file" "lambda_check_ebs_application_version_readiness" {
  type        = "zip"
  source_file = "files/lambda/check_ebs_application_version_readiness.py"
  output_path = "tmp/check_ebs_application_version_readiness.zip"
}

resource "aws_lambda_function" "lambda_check_ebs_application_version_readiness" {
  function_name    = "streetbees-check-ebs-application-version-readiness"
  filename         = data.archive_file.lambda_check_ebs_application_version_readiness.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "check_ebs_application_version_readiness.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_check_ebs_application_version_readiness.output_path)
}

data "archive_file" "lambda_evaluate_ebs_environments" {
  type        = "zip"
  source_file = "files/lambda/evaluate_ebs_environments.py"
  output_path = "tmp/evaluate_ebs_environments.zip"
}

resource "aws_lambda_function" "lambda_evaluate_ebs_environments" {
  function_name    = "streetbees-evaluate-ebs-environments"
  filename         = data.archive_file.lambda_evaluate_ebs_environments.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "evaluate_ebs_environments.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_evaluate_ebs_environments.output_path)
}

data "archive_file" "lambda_create_ebs_environment" {
  type        = "zip"
  source_file = "files/lambda/create_ebs_environment.py"
  output_path = "tmp/create_ebs_environment.zip"
}

resource "aws_lambda_function" "lambda_create_ebs_environment" {
  function_name    = "streetbees-create-ebs-environment"
  filename         = data.archive_file.lambda_create_ebs_environment.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "create_ebs_environment.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_create_ebs_environment.output_path)
}

data "archive_file" "lambda_deploy_ebs_application" {
  type        = "zip"
  source_file = "files/lambda/deploy_ebs_application.py"
  output_path = "tmp/deploy_ebs_application.zip"
}

resource "aws_lambda_function" "lambda_deploy_ebs_application" {
  function_name    = "streetbees-deploy-ebs-application"
  filename         = data.archive_file.lambda_deploy_ebs_application.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "deploy_ebs_application.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_deploy_ebs_application.output_path)
}

data "archive_file" "lambda_check_ebs_environment_readiness" {
  type        = "zip"
  source_file = "files/lambda/check_ebs_environment_readiness.py"
  output_path = "tmp/check_ebs_environment_readiness.zip"
}

resource "aws_lambda_function" "lambda_check_ebs_environment_readiness" {
  function_name    = "streetbees-check-ebs-environment-readiness"
  filename         = data.archive_file.lambda_check_ebs_environment_readiness.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "check_ebs_environment_readiness.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_check_ebs_environment_readiness.output_path)
}

data "archive_file" "lambda_terminate_ebs_environment" {
  type        = "zip"
  source_file = "files/lambda/terminate_ebs_environment.py"
  output_path = "tmp/terminate_ebs_environment.zip"
}

resource "aws_lambda_function" "lambda_terminate_ebs_environment" {
  function_name    = "streetbees-terminate-ebs-environment"
  filename         = data.archive_file.lambda_terminate_ebs_environment.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "terminate_ebs_environment.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_terminate_ebs_environment.output_path)
}

data "archive_file" "lambda_swap_ebs_blue_green" {
  type        = "zip"
  source_file = "files/lambda/swap_ebs_blue_green.py"
  output_path = "tmp/swap_ebs_blue_green.zip"
}

resource "aws_lambda_function" "lambda_swap_ebs_blue_green" {
  function_name    = "streetbees-swap-ebs-blue-green"
  filename         = data.archive_file.lambda_swap_ebs_blue_green.output_path
  role             = aws_iam_role.streetbees_deployment_role.arn
  handler          = "swap_ebs_blue_green.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  source_code_hash = filebase64sha256(data.archive_file.lambda_swap_ebs_blue_green.output_path)
}