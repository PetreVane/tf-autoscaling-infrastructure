# AWS Auto Scaling Infrastructure with Continuous Deployment

## Project Overview

This Terraform project sets up a complete AWS environment designed for a high-availability application using an Application Load Balancer (ALB), Auto Scaling Group (ASG), and dynamic scaling policies based on application load (ALB request count). The infrastructure automatically adjusts to the incoming traffic, ensuring efficient resource utilization and maintaining performance during demand spikes or declines.

Additionally, this project now includes a continuous deployment pipeline that automatically updates the application when changes are pushed to the repository.

If you want to see the application code of the (app) jar file stored in the S3 bucket, [look here](https://github.com/PetreVane/dummy-app)

## Prerequisites

Before deploying this Terraform project, you need to have the following:

- AWS Account: An active AWS account is required.
- AWS CLI: Installed and configured with your AWS credentials.
- Terraform: Terraform should be installed on your machine. Installation guides can be found on the [Terraform website](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Basic knowledge of AWS services such as EC2, ALB, VPC, IAM, Lambda, S3, and Auto Scaling.
- GitHub account: For the continuous deployment pipeline.

## Infrastructure Components

- **S3 Bucket**:
    - Stores application artefacts and Lambda function code.
    - Triggers Lambda function on new uploads.

- **IAM Roles and Policies**:
    - Ensures proper permission management for resources.
    - Creates read-only permission policy for S3 bucket.
    - Creates roles for EC2 instances and Lambda function.

- **VPC, Subnets, and Internet Gateway**: Provides the networking components.

- **Security Groups**: Manages access to resources within the VPC.

- **EC2 Instances via Launch Template**:
    - Used for templating application servers.

- **Auto Scaling Group**: Manages the scaling of EC2 instances based on defined criteria.

- **ALB (Application Load Balancer)**: Distributes incoming application traffic across multiple EC2 instances.

- **CloudWatch Alarms and Scaling Policies**: Monitors performance and triggers auto-scaling actions.

- **Lambda Function**:
    - Triggered by S3 uploads.
    - Executes SSM commands to update running EC2 instances with the new application version.

- **Systems Manager (SSM)**:
    - Stores documents for updating EC2 instances.
    - Allows remote execution of commands on EC2 instances.

- **Simple Notification Service (SNS)**:
    - Sends notifications about Lambda function execution results.

- **GitHub Module**:
    - Sets up IAM roles and policies for GitHub Actions.
    - Creates an OIDC provider for secure authentication between GitHub and AWS.
    - Configures SSM parameters to store important information like role ARNs and S3 bucket names.
    - Enables GitHub Actions to securely deploy to AWS without storing long-lived credentials.

## Continuous Deployment Pipeline

The project now includes a continuous deployment pipeline:

1. Application code is stored in a separate [GitHub repository](https://github.com/PetreVane/dummy-app)
2. When changes are pushed, a GitHub Actions workflow is triggered.
3. The workflow uses the IAM role created by the GitHub module to authenticate with AWS.
4. The workflow builds the application artifact and copies it to a S3 bucket.
5. S3 upload triggers a Lambda function.
6. Lambda function uses SSM to update all running EC2 instances with the new application version.

## Repository Structure

- `/modules`: Contains Terraform modules for each component (S3, IAM, VPC, Security Groups, Launch Template, Auto Scaling Group, ALB, Lambda, SSM, SNS, GitHub).
- `/main.tf`: The root Terraform configuration file that calls modules and integrates components.
- `/variables.tf`: Defines variables used in main Terraform configurations.
- `/outputs.tf`: Manages output configurations that are important post-deployment.

## Usage

To use this project, follow these steps:

1. **Clone the Repository:**

   git clone git@github.com:PetreVane/tf-autoscaling-infrastructure.git
   cd tf-autoscaling-infrastructure


2. **Initialize Terraform:**

   terraform init

3. **Plan the Deployment:**

   terraform plan

4. **Apply the Configuration:**

   terraform apply

5. **Check the Outputs:**
   Once applied, go to your AWS web console and inspect the newly created infrastructure.

6. **Set Up GitHub Actions:**
   In your application code repository, set up the GitHub Actions workflow to use the IAM role created by the GitHub module. Use the SSM parameters to retrieve necessary information like the role ARN and S3 bucket name.

7. **Destroy (if needed):**

   terraform destroy

## Recent Updates

- Added Lambda function to handle automatic updates of EC2 instances.
- Integrated S3 bucket notifications to trigger Lambda function on new uploads.
- Created SSM documents for remote execution of update commands on EC2 instances.
- Added SNS topic for execution notifications from Lambda function.
- Updated IAM roles and policies to support new components and their interactions.
- Implemented GitHub module for secure integration with GitHub Actions.
- Set up continuous deployment pipeline using GitHub Actions and S3 triggers.

## Note

Ensure all necessary permissions are set up correctly in AWS and that your GitHub repository has the required configuration for AWS authentication using the OIDC provider set up by the GitHub module. These include setting up 2 secrets in Github, such as AWS ACCOUNT ID and a default AWS Region, where the infrastructure will be deployed first time.
