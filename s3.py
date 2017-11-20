
import sys
from boto3.s3.transfer import S3Transfer
import boto3

AWS_ACCESS_KEY_ID=sys.argv[2]
AWS_SECRET_ACCESS_KEY=sys.argv[3]

bucket_name = 'acm-tmt-staging'
testfiles = ["report.html","log.html","output.xml"]
s3_app_path = "robot-result/mock-app"

client = boto3.client('s3', aws_access_key_id=AWS_ACCESS_KEY_ID,aws_secret_access_key=AWS_SECRET_ACCESS_KEY)
transfer = S3Transfer(client)

transfer.download_file(bucket_name, s3_app_path + "/buildno.txt", "buildno.txt")
buildno = ''
with open('buildno.txt', 'r') as content_file:
    buildno = content_file.read()
buildno = str(int(buildno)+1)
with open('buildno.txt', 'w') as content_file:
    content_file.write(buildno)


for fi in testfiles:
    fullpath = s3_app_path + "/" + buildno + "/report"
    print 'Uploading '+fi+' to Amazon S3 ' + bucket_name + "/" + fullpath + "/" + fi
    transfer.upload_file(sys.argv[1] +"/"+fi, bucket_name, fullpath + "/" + fi)

transfer.upload_file("buildno.txt", bucket_name, s3_app_path + "/buildno.txt")
