# Swap blue & green environments with each other (changes URL and EBS_BlueGreen tag)
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


#
# Example event format:
#
# {
#   "blueEnvironmentName": "streetbees-cats-env-BH7MQ"
#   "greenEnvironmentName": "streetbees-cats-env-HJK6Y"
# }
#

def lambda_handler(event, context):
    blue_environment_name = event['blueEnvironmentName']
    green_environment_name = event['greenEnvironmentName']
    
    beanstalk_client = boto3.client('elasticbeanstalk')

    # Get ARNs for blue and green environments
    logger.info('Retrieving info for blue & green environments...')
    blueGreenEnvironments = beanstalk_client.describe_environemnts(
        EnvironmentNames=[blue_environment_name, green_environment_name],
        IncludeDeleted=False
    )
    logger.info(blueGreenEnvironments)
    blue_environment_arn = None
    green_environment_arn = None
    for env in blueGreenEnvironments['Environments']:
        if env['EnvironmentName'] == green_environment_name:
            green_environment_arn = env['EnvironmentArn']
        elif env['EnvironmentName'] == blue_environment_name:
            blue_environment_arn = env['EnvironmentArn']

    # Update tags to reflect swapping of blue and green environments
    logger.info('Updating tag for new green environment...')
    response = beanstalk_client.update_tags_for_resource(
        ResourceArn=blue_environment_arn,
        TagsToAdd=[{
            'Key': 'EBS_BlueGreen',
            'Value': 'green'
        }]
    )
    logger.info(response)

    logger.info('Updating tag for old green environment...')
    response = beanstalk_client.update_tags_for_resource(
        ResourceArn=green_environment_arn,
        TagsToAdd=[{
            'Key': 'EBS_BlueGreen',
            'Value': 'blue'
        }]
    )

    # Swap blue and green environment URLs to redirect traffic to the new green environment
    logger.info('Swapping blue & green environment URLs...')
    response = beanstalk_client.swap_environment_cnames(
        SourceEnvironmentName = green_environment_name,
        DestinationEnvironmentName = blue_environment_name
    )
    logger.info(response)

    event['environment_name'] = blue_environment_name  # pass back the new green environment to monitor readiness
    return event
