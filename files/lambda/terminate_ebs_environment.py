# Terminate a Beanstalk Environment
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


#
# Example event format:
#
# {
#   "environmentName": "streetbees-cats-env-BH7MQ"
# }
#


def lambda_handler(event, context):
    environment_name = event['environmentName']

    logger.info('Terminating environment %s...' % environment_name)
    beanstalk_client = boto3.client('elasticbeanstalk')
    response = beanstalk_client.terminate_environment(
        EnvironmentName=environment_name,
        TerminateResources=True
    )
    logger.info(response)

    return event