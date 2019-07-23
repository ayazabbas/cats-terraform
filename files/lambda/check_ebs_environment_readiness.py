import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#
# Example event format:
#
# {
#   "environmentName": "streetbees-cats-env-green-9DO5A"
# }
#

def lambda_handler(event, context):
    environment_name = event['environmentName']

    beanstalk_client = boto3.client('elasticbeanstalk')
    logger.info('Requesting environment health status info...')
    response = beanstalk_client.describe_environments(
        EnvironmentNames=[environment_name]
    )
    logger.info(response)

    env = response['Environments'][0]

    event['environmentStatus'] = env['Status']
    event['environmentHealth'] = env['Health']
    return event
