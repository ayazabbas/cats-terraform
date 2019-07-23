# Check for currently running Beanstalk Environments
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def get_tag_value(ResourceTypes: list, ResourceARN, TagKey):
    restag_client = boto3.client('resourcegroupstaggingapi')
    logging.info('Searching for resources with tag %s...' % TagKey)
    response = restag_client.get_resources(
        TagFilters=[
            {
                'Key': TagKey
            }
        ],
        ResourceTypeFilters=ResourceTypes
    )
    logging.info(response)
    target_resource = next(item for item in response['ResourceTagMappingList'] if item['ResourceARN'] == ResourceARN)
    tag_value = next(item for item in target_resource['Tags'] if item['Key'] == TagKey)['Value']
    logging.info('%s -- %s' % (ResourceARN, tag_value))
    return tag_value


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

    desired_version_label = '%s-%s' % (app_name, app_version)

    beanstalk_client = boto3.client('elasticbeanstalk')
    logger.info('Querying for currently running environments...')
    response = beanstalk_client.describe_environments(
        ApplicationName=app_name,
        IncludeDeleted=False
    )
    logger.info(response)
    environments = response['Environments']

    # These variables determine how to proceed
    green_env_name = None
    blue_env_name = None
    green_env_live = True  # is any version of the app currently running and live?
    desired_version_deployed_green = False
    desired_version_deployed_blue = False

    for env in environments:
        env_name = env['EnvironmentName']
        env_health = env['Health']
        env_arn = env['EnvironmentArn']

        try:
            running_version_label = env['VersionLabel']
        except KeyError:
            running_version_label = None

        if env_health != 'Red' or 'Grey':  # ignore envs not in operation
            if get_tag_value(ResourceTypes=['elasticbeanstalk'], ResourceARN=env_arn, TagKey='EBS_BlueGreen') == 'green':
                green_env_name = env_name
                if running_version_label == None:
                    green_env_live = False
                logger.info('Found green environment, checking application version...')
                desired_version_deployed_green = (running_version_label == desired_version_label)
            elif get_tag_value(ResourceTypes=['elasticbeanstalk'], ResourceARN=env_arn, TagKey='EBS_BlueGreen') == 'blue':
                blue_env_name = env_name
                logger.info('Found blue environment, checking application version...')
                desired_version_deployed_blue = (running_version_label == desired_version_label)

    logging.info('Green environment: %s' % green_env_name)
    logging.info('Blue environment: %s' % blue_env_name)
    logging.info('green_env_live: %s' % green_env_live)
    logging.info('desired_version_deployed_green: %s' % desired_version_deployed_green)
    logging.info('desired_version_deployed_blue: %s' % desired_version_deployed_blue)

    if green_env_name:
        if desired_version_deployed_green:
            if blue_env_name:
                # terminate blue environment
                event['environmentName'] = blue_env_name
                event['nextState'] = 'TerminateEBSEnvironment'
                return event
            else:
                # nothing to do
                event['nextState'] = 'PipelineSuccess'
                return event
        else:
            if not green_env_live:  # green env is up but application not deployed
                # deploy desired version to green
                event['environmentName'] = green_env_name
                event['nextState'] = "DeployToEBSEnvironment"
            elif blue_env_name:
                if desired_version_deployed_blue:
                    # Swap blue and green
                    event['blueEnvironmentName'] = blue_env_name
                    event['greenEnvironmentName'] = green_env_name
                    event['nextState'] = 'SwapEBSBlueGreen'
                else:
                    # Deploy desired version to blue
                    event['environmentName'] = blue_env_name
                    event['nextState'] = 'DeployToEBSEnvironment'
            else:
                # Create blue environment
                event['blueGreen'] = 'blue'
                event['nextState'] = 'CreateEBSEnvironment'
    else:
        # Create green environment
        event['blueGreen'] = 'green'
        event['nextState'] = 'CreateEBSEnvironment'

    return event
