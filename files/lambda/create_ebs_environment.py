import boto3
import logging
import random
import string

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#
# Example event format:
#
# {
#   "appName": "streetbees-cats",
#   "templateName": "streetbees-cats-configuration",
#   "blueGreen": "green"
# }
#

def lambda_handler(event, context):
    app_name = event['appName']
    template_name = event['templateName']
    blue_green = event['blueGreen']

    # if creating a blue environment (for the updated version), the cname should be different
    cname_prefix = app_name if (blue_green == 'green') else '%s-blue' % app_name

    # Environment name needs to be unique because Beanstalk can take a while to fully remove terminated environments
    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=5))
    environment_name = '%s-env-%s' % (app_name, random_string)

    beanstalk_client = boto3.client('elasticbeanstalk')
    logger.info('Creating beanstalk environment...')
    response = beanstalk_client.create_environment(
        ApplicationName=app_name,
        EnvironmentName=environment_name,
        CNAMEPrefix=cname_prefix,
        TemplateName=template_name,
        Tier={
            'Name': 'WebServer',
            'Type': 'Standard'
        },
        Tags=[
            {
                'Key': 'EBS_BlueGreen',
                'Value': blue_green
            },
        ]
    )
    logger.info(response)

    event['environmentName'] = environment_name
    return event
