resource "random_id" "generator" {
  byte_length = 4
}

resource "aws_ssm_document" "tf_ssm_document" {
  name          = "tf_ssm_document_shell_script-${random_id.generator.hex}-v5"
  document_type = "Command"
  content       = <<DOCUMENT
{
  "schemaVersion": "2.2",
  "description": "Update Java application step-by-step",
  "parameters": {
    "bucketName": {
      "type": "String",
      "description": "Name of the S3 bucket"
    },
    "jarKey": {
      "type": "String",
      "description": "S3 key of the JAR file"
    }
  },
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "KillJavaProcess",
      "inputs": {
        "timeoutSeconds": 60,
        "runCommand": [
          "echo 'Killing Java process' > /home/ec2-user/update_log.txt",
          "pid=$(pgrep -f 'java -jar')",
          "if [ -n \"$pid\" ]; then",
          "  sudo kill -9 $pid",
          "  echo 'Java process killed' >> /home/ec2-user/update_log.txt",
          "else",
          "  echo 'No Java process found' >> /home/ec2-user/update_log.txt",
          "fi"
        ]
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "CopyJarFromS3",
      "inputs": {
        "timeoutSeconds": 300,
        "runCommand": [
          "echo 'Copying JAR from S3' >> /home/ec2-user/update_log.txt",
          "echo 'Bucket: {{bucketName}}, Key: application/jar/{{jarKey}}' >> /home/ec2-user/update_log.txt",
          "echo 'AWS CLI version:' >> /home/ec2-user/update_log.txt",
          "aws --version >> /home/ec2-user/update_log.txt 2>&1",
          "echo 'Current user:' >> /home/ec2-user/update_log.txt",
          "id >> /home/ec2-user/update_log.txt 2>&1",
          "echo 'Environment variables:' >> /home/ec2-user/update_log.txt",
          "env | grep AWS >> /home/ec2-user/update_log.txt 2>&1",
          "aws s3 cp s3://{{bucketName}}/application/jar/{{jarKey}} /home/ec2-user/dummy-webapp.jar",
          "COPY_RESULT=$?",
          "if [ $COPY_RESULT -eq 0 ]; then",
          "  echo 'JAR file copied successfully' >> /home/ec2-user/update_log.txt",
          "else",
          "  echo 'Failed to copy JAR file. Error code: '$COPY_RESULT >> /home/ec2-user/update_log.txt",
          "  echo 'Attempting copy without sudo:' >> /home/ec2-user/update_log.txt",
          "  su ec2-user -c 'aws s3 cp s3://{{bucketName}}/application/jar/{{jarKey}} /home/ec2-user/dummy-webapp.jar' >> /home/ec2-user/update_log.txt 2>&1",
          "  echo 'Checking S3 bucket access:' >> /home/ec2-user/update_log.txt",
          "  aws s3 ls s3://{{bucketName}}/application/jar/ >> /home/ec2-user/update_log.txt 2>&1",
          "  echo 'Checking specific object:' >> /home/ec2-user/update_log.txt",
          "  aws s3api head-object --bucket {{bucketName}} --key application/jar/{{jarKey}} >> /home/ec2-user/update_log.txt 2>&1",
          "  echo 'Checking IAM role:' >> /home/ec2-user/update_log.txt",
          "  aws sts get-caller-identity >> /home/ec2-user/update_log.txt 2>&1",
          "  exit 1",
          "fi"
        ]
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "ChangePermissions",
      "inputs": {
        "timeoutSeconds": 60,
        "runCommand": [
          "echo 'Changing JAR file permissions' >> /home/ec2-user/update_log.txt",
          "sudo chown ec2-user:ec2-user /home/ec2-user/dummy-webapp.jar",
          "sudo chmod 644 /home/ec2-user/dummy-webapp.jar",
          "echo 'Permissions changed' >> /home/ec2-user/update_log.txt"
        ]
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "StartNewJavaProcess",
      "inputs": {
        "timeoutSeconds": 60,
        "runCommand": [
          "echo 'Starting new Java process' >> /home/ec2-user/update_log.txt",
          "nohup java -jar /home/ec2-user/dummy-webapp.jar > /home/ec2-user/app.log 2>&1 &",
          "sleep 5",
          "if pgrep -f 'java -jar' > /dev/null; then",
          "  echo 'New Java process started successfully' >> /home/ec2-user/update_log.txt",
          "else",
          "  echo 'Failed to start new Java process' >> /home/ec2-user/update_log.txt",
          "  exit 1",
          "fi"
        ]
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "VerifyUpdate",
      "inputs": {
        "timeoutSeconds": 60,
        "runCommand": [
          "echo 'Verifying update' >> /home/ec2-user/update_log.txt",
          "ps aux | grep 'java -jar' >> /home/ec2-user/update_log.txt",
          "echo 'Update process completed' >> /home/ec2-user/update_log.txt"
        ]
      }
    }
  ]
}
DOCUMENT
}