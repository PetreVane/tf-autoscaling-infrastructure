#!/bin/bash

# Update the system
sudo yum update -y

# Install Java 17
sudo yum install java-17-amazon-corretto-headless -y

# Copy the jar artifact to the home directory
aws s3 cp s3://${BUCKET_NAME}/${JAR_KEY} /home/ec2-user

# Change permissions
sudo chown ec2-user:ec2-user /home/ec2-user/dummy-webapp.jar

# Start the application and log the output
java -jar /home/ec2-user/dummy-webapp.jar 1>/home/ec2-user/log.txt 2>&1 &
