# Check if desired application version already exists in Beanstalk
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
    app_name = event['appName']
    app_version = event['appVersion']

    beanstalk_client = boto3.client('elasticbeanstalk')
    logger.info('Querying application versions...')
    response = beanstalk_client.describe_application_versions(
        ApplicationName=app_name
    )
    logger.info(response)

    application_versions = response['ApplicationVersions']

    # Check if desired version already exists
    for version in application_versions:
        if version['VersionLabel'] == '%s-%s' % (app_name, app_version):
            logger.info('Version already exists')
            event['versionExists'] = True
            return event

    # If we have reached beyond the for loop, the current version does not exist and must be created
    logger.info('Version %s does not exist and must be created' % app_version)
    event['versionExists'] = False
    return event
