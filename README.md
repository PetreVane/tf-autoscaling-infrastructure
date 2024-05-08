

# AWS Auto Scaling Infrastructure

## Project Overview

This Terraform project sets up a complete AWS environment designed for a high-availability application using an Application Load Balancer (ALB), 
Auto Scaling Group (ASG), and dynamic scaling policies based on application load (ALB request count). 
The infrastructure automatically adjusts to the incoming traffic, ensuring efficient resource utilization and maintaining performance during demand spikes or declines.

If you want to see the application code of the (app) jar file stored in the s3 bucket, [look here](https://github.com/PetreVane/dummy-app) 

## Prerequisites

Before deploying this Terraform project, you need to have the following:

- AWS Account: An active AWS account is required.
- AWS CLI: Installed and configured with your AWS credentials.
- Terraform: Terraform should be installed on your machine. Installation guides can be found on the [Terraform website](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Basic knowledge of AWS services such as EC2, ALB, VPC, IAM, and Autoscaling.

## Infrastructure Components

- **S3 Bucket**: Stores application artifacts.
   - it creates a s3 bucket and uploads an application artifact to it    
- **IAM Roles and Policies**: Ensures proper permission management for resources.
   - it creates a read only permission policy for s3 bucket
   - it then creates a new role, a policy attachment and a instance profile
- **VPC, Subnets, and Internet Gateway**: Provides the networking components.
   - it creates a vpc, with 3 public subnets, a route table and a internet gateway
- **Security Groups**: Manages access to resources within the VPC.
   - it creates a security group which allows access to 8080 and 22, for ec2-instance connect 
- **EC2 Instances via Launch Template**: Used for templating application servers.
   - it creates a launch template which uses an amazon ami on a t2.micro instance type
   - it attaches an ec2-instance profile to all ec2 instances created with this template and it runs a bash script as user-metadata on each
   - the bash script gets the jar artifact stored on the s3 bucket, it then changes permissions and runs it
- **Auto Scaling Group**: Manages the scaling of EC2 instances based on defined criteria.
   - it uses the launch template to deploy a ec2 instance in one subnet, with the posibility of increasing the maximum capacity to 3 
- **ALB (Application Load Balancer)**: Distributes incoming application traffic across multiple EC2 instances, enhancing fault tolerance.
   - it listens for connections on port 8080 and redirects traffic to a target group. The application is also listening for connections on port 8080 
- **CloudWatch Alarms and Scaling Policies**: Monitors performance and triggers auto-scaling actions to adjust capacity in response to operational demands.
   - it creates a dynamic scaling policy which uses Target Tracking Scaling and ALBRequestCountPerTarget metric to dynamically scale out or in the number of available ec2 instances.
   - scaling out or in happens as result of increased / decreased traffic detected by cloudwatch monitoring
## Repository Structure

- `/modules`: Contains Terraform modules for each component.
- `/main.tf`: The root Terraform configuration file that calls modules and integrates components.
- `/variables.tf`: Defines variables used in main Terraform configurations.
- `/outputs.tf`: Manages output configurations that are important post-deployment.

## Usage

To use this project, follow these steps:

1. **Clone the Repository:**
   ```
    git clone git@github.com:PetreVane/tf-autoscaling-infrastructure.git
    cd tf-autoscaling-infrastructure
   ```

2. **Initialize Terraform:**
   ```
    terraform init
   ```

3. **Plan the Deployment:**
   Visualize the changes Terraform will make as per the current configuration.
   ```
    terraform plan
   ```

4. **Apply the Configuration:**
   Deploy your infrastructure.
   ```
    terraform apply
   ```

5. **Check the Outputs:**
   Once applied, go to your AWS web console and inspect the newly created infrastructure.

6. **Destroy (if needed):**
   Remove all resources created by Terraform.
   ```
    terraform destroy
   ```



