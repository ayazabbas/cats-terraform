data "template_file" "sfn_blue_green_ebs_deployment" {
  template = "${file("files/stepfunctions/sfn_blue_green_ebs_pipeline.json.tmpl")}"

  vars = {
    evaluate_ebs_application_version_lambda        = aws_lambda_function.lambda_evaluate_ebs_application_versions.arn
    create_ebs_application_version_lambda          = aws_lambda_function.lambda_create_ebs_application_version.arn
    check_ebs_application_version_readiness_lambda = aws_lambda_function.lambda_check_ebs_application_version_readiness.arn
    evaluate_ebs_environments_lambda               = aws_lambda_function.lambda_evaluate_ebs_environments.arn
    create_ebs_environment_lambda                  = aws_lambda_function.lambda_create_ebs_environment.arn
    check_ebs_environment_readiness_lambda         = aws_lambda_function.lambda_check_ebs_environment_readiness.arn
    terminate_ebs_environment_lambda               = aws_lambda_function.lambda_terminate_ebs_environment.arn
    deploy_ebs_application_lambda                  = aws_lambda_function.lambda_deploy_ebs_application.arn
    swap_ebs_blue_green_lambda                     = aws_lambda_function.lambda_swap_ebs_blue_green.arn
  }
}

resource "aws_sfn_state_machine" "sfn_blue_green_ebs_deployment" {
  name       = "streetbees-state-machine-ebs-deployment"
  role_arn   = aws_iam_role.streetbees_deployment_role.arn
  definition = data.template_file.sfn_blue_green_ebs_deployment.rendered
}

data "template_file" "streetbees_cats_pipeline_input" {
  template = "${file("files/stepfunctions/sfn_blue_green_ebs_pipeline_input.json.tmpl")}"

  vars = {
    app_name      = aws_elastic_beanstalk_application.streetbees_cats.name
    app_version   = var.app_version
    s3_bucket     = aws_s3_bucket.streetbees_deployment_bucket.bucket
    s3_key        = aws_s3_bucket_object.streetbees_cats_archive.key
    template_name = aws_elastic_beanstalk_configuration_template.streetbees_cats_configuration.name
  }
}

resource "local_file" "streetbees_cats_pipeline_input" {
  content  = data.template_file.streetbees_cats_pipeline_input.rendered
  filename = "tmp/streetbees-cats-pipeline-input.json"
}

resource "local_file" "state_machine_arn" {
  content  = aws_sfn_state_machine.sfn_blue_green_ebs_deployment.id
  filename = "tmp/state-machine-arn.txt"
}
