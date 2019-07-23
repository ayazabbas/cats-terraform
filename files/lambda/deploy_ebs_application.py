import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#
# Example event format:
#
# {
#   "appName": "streetbees-cats",
#   "appVersion": "1.0.0",
#   "environmentName": "streetbees-cats-env"
# }
#


def lambda_handler(event, context):
    app_name = event['appName']
    app_version = event['appVersion']
    environment_name = event['environmentName']

    beanstalk_client = boto3.client('elasticbeanstalk')
    logger.info('Updating beanstalk environment...')
    response = beanstalk_client.update_environment(
        ApplicationName=app_name,
        EnvironmentName=environment_name,
        VersionLabel='%s-%s' % (app_name, app_version)
    )
    logger.info(response)

    return event
