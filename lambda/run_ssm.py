import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ssm_client = boto3.client("ssm")
sns_client = boto3.client("sns")
asg_client = boto3.client('autoscaling')
ec2_client = boto3.client('ec2')

def handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    jar_filename = key.split('/')[-1]  # Extract just the filename
    asg_name = os.environ['asg_name']
    ssm_document_name = os.environ['ssm_document_name']
    sns_topic_arn = os.environ['sns_topic_arn']

    try:
        # Get instance IDs from ASG
        asg_response = asg_client.describe_auto_scaling_instances()
        instance_ids = [i['InstanceId'] for i in asg_response['AutoScalingInstances'] if i['AutoScalingGroupName'] == asg_name]

        if not instance_ids:
            raise Exception(f'No instance found in ASG {asg_name}')

        # Get instance states
        ec2_response = ec2_client.describe_instance_status(InstanceIds=instance_ids)
        valid_instance_ids = [instance['InstanceId'] for instance in ec2_response['InstanceStatuses'] if instance['InstanceState']['Name'] == 'running']

        if not valid_instance_ids:
            raise Exception(f'No valid running instances found in ASG {asg_name}')

        response = ssm_client.send_command(
            InstanceIds=valid_instance_ids,
            DocumentName=ssm_document_name,
            Comment='Triggered by S3 Upload'
        )
        message = f'SSM Document {ssm_document_name} executed successfully on all instances of ASG {asg_name}'
        logger.info(message)

        # Send notification
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=message,
            Subject='SSM Execution Success'
        )
        return response

    except Exception as e:
        error_message = f"Error executing SSM document {ssm_document_name} on instances of ASG {asg_name}: {str(e)}"
        logger.error(error_message)

        # Send notification
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=error_message,
            Subject='SSM Execution Failure'
        )
        raise e
