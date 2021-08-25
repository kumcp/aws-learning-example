import json
import boto3
import random, string
from boto3.dynamodb.conditions import Key, Attr


def lambda_handler(event, context):


    bucketName = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']

    
    # Get the service resource.
    dynamodb = boto3.resource('dynamodb')
    
    # Change table name
    table = dynamodb.Table('test')

    
    chars=string.ascii_uppercase + string.digits
    randomId = ''.join(random.choice(chars) for _ in range(8))
    
    table.put_item(Item={
        'id': randomId,
        'file_key': file_key,
        'bucket': bucketName,
    })
    
    return {
        'statusCode': 200,
        'body': []
    }
    

