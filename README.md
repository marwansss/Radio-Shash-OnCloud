# Radioshash

## Project Overview

Radioshash is a deep learning model designed to predict the presence and type of brain tumors. It has been packaged into a user-friendly Flask web application. Initially developed as a college graduation project at Pharos University in Alexandria (PUA), the application has been enhanced with a range of DevOps tools to optimize and deploy it on the cloud rather than on-premises hosts.

### Features

- **Deep Learning Model**: Predicts the presence and type of brain tumors.
- **Flask Web Application**: A user-friendly interface for interaction with the model.
- **Optimized Docker Containers**: Uses multi-stage builds to reduce image size from 4.5GB to 2.36GB.
- **Kubernetes Orchestration**: Ensures the application runs in a reliable environment.
- **Infrastructure as Code (IaC)**: Utilizes Terraform for provisioning infrastructure on AWS.
- **Configuration Management**: Uses Ansible to manage configurations across EC2 instances and Kubernetes clusters using kube-adm tool for production purposes.
- **CI/CD Pipeline**: Automated software lifecycle management using Jenkins.

## Documentation

### Getting Started

These instructions will help you set up the project's infrastructure and get the application running.

#### Prerequisites

- **Terraform**: Install Terraform on your local machine to apply the Terraform code.

#### Terraform Setup

Terraform is used to automatically provision and manage the cloud infrastructure required for the Radioshash project on AWS. Below are the specific responsibilities handled by Terraform in this project:

1. **AWS RDS Instance**: Provisions an Amazon RDS instance that hosts the application database.
2. **EC2 Instance for Jenkins**: Sets up an Amazon EC2 instance to serve as the Jenkins server.
3. **AWS Backup Service**: Configures AWS Backup to take daily snapshots of the Jenkins EC2 instance.
4. **ELB Access Log Storage**: Saves access logs from the Elastic Load Balancer to an AWS S3 bucket.
5. **AWS Elastic Container Registry (ECR)**: Creates an AWS ECR repository to store Docker images.
6. **AWS CloudWatch Dashboard for Kubernetes Cluster**: Automates the creation of a CloudWatch dashboard to monitor the Kubernetes cluster.

To apply the Terraform configurations:

terraform init # Initialize Terraform, install providers
terraform plan # Review the infrastructure plan
terraform apply # Apply the configuration to create the infrastructure

![Example GIF](/assets/Project.gif)



#### Configure Jenkins EC2 Instance

- Once the infrastructure is set up, SSH into your Jenkins EC2 instance. This instance acts as a bastion host as well as the Jenkins server.
- Run the following script to install Ansible on the Jenkins EC2:

./Install_Ansible.sh



- Execute Ansible playbooks to configure the Kubernetes cluster using kube-adm tool, cloud agents on all EC2 instances, and the Jenkins EC2 itself with the necessary packages and configurations:

cd Ansible
Run all playbooks inside this Directory



#### Deploy Using Jenkins

- Access your Jenkins dashboard to run the pipeline (File: Jenkins) which will:
- Build and push Docker images to AWS ECR.
- Deploy the application to Kubernetes.

#### Usage

- Access the application via the URL provided by your Elastic Load Balancer (ELB) in AWS.
- Interact with the deep learning model through the Flask web interface to predict brain tumors.

### Monitoring and Maintenance

- **AWS CloudWatch**: Monitor the Kubernetes cluster and EC2 instances.
- **S3 Buckets**: Store ELB access logs and the deep learning model file used in building docker image.
- **AWS Backup**: Automate snapshot creation for Jenkins EC2 machine.

Enjoy using Radioshash for detecting and understanding brain tumors through cutting-edge technology and cloud infrastructure!
