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
#   "s3Bucket": "streetbees-deployment-bucket-858463413507",
#   "s3Key": "cats/cats-1.0.0.zip"
# }
#

def lambda_handler(event, context):
    app_name = event['appName']
    app_version = event['appVersion']
    s3_bucket = event['s3Bucket']
    s3_key = event['s3Key']

    beanstalk_client = boto3.client('elasticbeanstalk')
    s3_client = boto3.client('s3')

    # download application archive
    logger.info('Downloading application archive from S3...')
    response = s3_client.download_file(s3_bucket, s3_key, '/tmp/app.zip')
    logger.info(response)

    # check if application version already exists
    application_versions = beanstalk_client.describe_application_versions(
        ApplicationName=app_name,
    )
    logger.info(application_versions)
    for version in application_versions['ApplicationVersions']:
        if version['VersionLabel'] == '%s-%s' % (app_name, app_version):
            logger.info("Version already exists")
            return

    # create application application version
    logger.info('Creating beanstalk application version...')
    response = beanstalk_client.create_application_version(
        ApplicationName=app_name,
        VersionLabel='%s-%s' % (app_name, app_version),
        SourceBundle={
            'S3Bucket': s3_bucket,
            'S3Key': s3_key
        },
        Process=True
    )
    logger.info(response)

    return event
