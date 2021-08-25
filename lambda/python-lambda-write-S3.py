import json
import boto3

def lambda_handler(event, context):
    
    string = "Test content"
    encoded_string = string.encode("utf-8")
    
    target_dir = 'log'
    bucket_name="s3-demo"
    file_name="test.log"
    

    s3_path = target_dir + '/' + file_name

    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Uploaded file to S3')
    }

