import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#
# Example event format:
#
# {
#   "appName": "streetbees-cats",
#   "appVersion": "1.0.0"
# }
#


def lambda_handler(event, context):
    # These runtime vars should be passed to the function in the event
    app_name = event['appName']
    app_version = event['appVersion']

    beanstalk_client = boto3.client('elasticbeanstalk')
    logger.info('Requesting environment health status info...')
    response = beanstalk_client.describe_application_versions(
        ApplicationName=app_name,
        VersionLabels=['%s-%s' % (app_name, app_version)]
    )
    logger.info('Response')

    version = response['ApplicationVersions'][0]
    event['versionStatus'] = version['Status']
    return event
