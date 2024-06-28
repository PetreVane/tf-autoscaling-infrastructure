#!/bin/bash

# Define variables
BUCKET_NAME=$1
JAR_KEY=$2
JAR_FILE="/home/ec2-user/dummy-webapp.jar"
LOG_FILE="/home/ec2-user/log.txt"

# Update the system
sudo yum update -y
sudo yum install -y amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
# Install Java 17
sudo yum install java-17-amazon-corretto-headless -y

# Copy the JAR artifact to the home directory
aws s3 cp s3://${BUCKET_NAME}/${JAR_KEY} $JAR_FILE

# Change permissions
sudo chown ec2-user:ec2-user $JAR_FILE

# Start the application and log the output
java -jar $JAR_FILE 1>$LOG_FILE 2>&1 &
