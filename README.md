
```markdown
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
- **IAM Roles and Policies**: Ensures proper permission management for resources.
- **VPC, Subnets, and Internet Gateway**: Provides the networking foundation.
- **Security Groups**: Manages access to resources within the VPC.
- **EC2 Instances via Launch Template**: Utilized for hosting application servers.
- **Auto Scaling Group**: Manages the scaling of EC2 instances based on defined criteria.
- **ALB (Application Load Balancer)**: Distributes incoming application traffic across multiple EC2 instances, enhancing fault tolerance.
- **CloudWatch Alarms and Scaling Policies**: Monitors performance and triggers auto-scaling actions to adjust capacity in response to operational demands.

## Repository Structure

- `/modules`: Contains Terraform modules for each component.
- `/main.tf`: The root Terraform configuration file that calls modules and integrates components.
- `/variables.tf`: Defines variables used in main Terraform configurations.
- `/outputs.tf`: Manages output configurations that are important post-deployment.

## Usage

To use this project, follow these steps:

1. **Clone the Repository:**
   ```
git clone https://github.com/your-repository/your-project-name.git
cd your-project-name
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
   Once applied, Terraform provides outputs defined in `outputs.tf` that can be helpful for further configurations or access details.

6. **Destroy (if needed):**
   Remove all resources created by Terraform.
   ```
terraform destroy
   ```
```


