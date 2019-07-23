data "template_file" "sfn_blue_green_ebs_deployment" {
  template = "${file("files/stepfunctions/sfn_blue_green_ebs_pipeline.json.tmpl")}"

  vars = {
    evaluate_ebs_application_version_lambda        = aws_lambda_function.lambda_evaluate_ebs_application_versions.arn
    create_ebs_application_version_lambda          = aws_lambda_function.lambda_create_ebs_application_version.arn
    check_ebs_application_version_readiness_lambda = aws_lambda_function.lambda_check_ebs_application_version_readiness.arn
    evaluate_ebs_environments_lambda               = aws_lambda_function.lambda_evaluate_ebs_environments.arn
    create_ebs_environment_lambda                  = aws_lambda_function.lambda_create_ebs_environment.arn
    check_ebs_environment_readiness_lambda         = aws_lambda_function.lambda_check_ebs_environment_readiness.arn
  }
}

resource "aws_sfn_state_machine" "streetbees_deployment_role" {
  name       = "streetbees-state-machine-ebs-deployment"
  role_arn   = aws_iam_role.streetbees_deployment_role.arn
  definition = data.template_file.sfn_blue_green_ebs_deployment.rendered
}
