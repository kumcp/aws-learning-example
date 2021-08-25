import json
import boto3
import random, string
from boto3.dynamodb.conditions import Key, Attr


def lambda_handler(event, context):
    
    # Get the service resource.
    dynamodb = boto3.resource('dynamodb')
    
    table = dynamodb.Table('test')
    
    # response = table.get_item(
    #     Key={
    #         'id': '3',
    #     }
    # ) 
    # result = query_items(table, Key('id').eq("3"))
    
    # result = scan_items(table, Attr('age').gt(0))
    
    chars=string.ascii_uppercase + string.digits
    randomName = ''.join(random.choice(chars) for _ in range(8))
    
    table.put_item(Item={
        'id': "5",
        'username': 'thanhcv',
        'name': 'thanh cao',
        'age': 25,
        'account_type': 'standard_user',
    })
    
    return {
        'statusCode': 200,
        'body': []
    }
    

def scan_items(table, expression):
    response = table.scan(
         FilterExpression=expression
    )
    
    return response['Items']
    
    
    
def query_items(table, expression):
    response = table.query(
        KeyConditionExpression=expression
    )
    
    return response['Items']
    


def get_item_by_id(table, id):
    response = table.get_item(
        Key={
            'id': id,
        }
    )
    
    return response['Item']
