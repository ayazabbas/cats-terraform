resource "aws_elastic_beanstalk_application" "streetbees_cats" {
  name        = "streetbees-cats"
  description = "Ruby Web app for cat lovers."
}

resource "aws_elastic_beanstalk_configuration_template" "streetbees_cats_configuration" {
  name                = "streetbees-cats-configuration"
  application         = aws_elastic_beanstalk_application.streetbees_cats.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.6 running Ruby 2.6 (Puma)"
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }
}
