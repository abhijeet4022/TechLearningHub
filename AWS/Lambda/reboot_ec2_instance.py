import boto3
region = 'ap-northeast-3'
instances = ['i-0625710743d7eb659']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.reboot_instances(InstanceIds=instances)
    print('rebooted your instances: ' + str(instances))