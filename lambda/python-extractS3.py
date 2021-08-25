import boto3
import string
import random
import os
import zipfile
def lambda_handler(event, context):
    s3_resource= boto3.resource('s3')
    s3_client= boto3.client('s3')
    bucketName = event['Records'][0]['s3']['bucket']['name']
    bucket = s3_resource.Bucket(bucketName)
    zip_key = event['Records'][0]['s3']['object']['key']


    chars=string.ascii_uppercase + string.digits
    randomName = ''.join(random.choice(chars) for _ in range(8))
    tmpFolder = '/tmp/' +  randomName + '/'
    os.makedirs(tmpFolder)
    unzipTmpFile= randomName + '.zip'
    attachmentFolder=''
    extension = ".zip"
    targetDirectory = 'extracted-folder'

    s3_client.download_file(bucketName, zip_key, tmpFolder + unzipTmpFile)
    dir_name = tmpFolder
    os.chdir(dir_name)

    for item in os.listdir(tmpFolder):
      if item.endswith(extension):
        file_name = os.path.abspath(item)
        zip_ref = zipfile.ZipFile(file_name)
        zip_ref.extractall(dir_name)
        zip_ref.close()
        os.remove(file_name)

    mrssFiles = []
    # r=root, d=directories, f = files
    for r, d, f in os.walk(tmpFolder):
      for file in f:
        mrssFiles.append(os.path.join(r, file))
    for file_name in mrssFiles:
      s3_client.upload_file(file_name, bucketName, targetDirectory + '/' + file_name.replace(tmpFolder, '', 1))
      os.remove(file_name)
    return {
        'statusCode': 200,
        'body': zip_key
    }
