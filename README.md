## Terraform Project: Learning Terraform with AWS 🚀

### Original Credit: 
The initial foundation of this project was based on a YouTube tutorial by **Abhishek Veeramalla** & **CloudChamp**. The project was then modified and extended with additional features to further enhance my understanding of Terraform and to gain practical experience with AWS infrastructure. ⚡

### Purpose
The primary purpose of this project is to gain hands-on experience with Terraform by provisioning cloud infrastructure on AWS while implementing essential infrastructure components such as EC2 instances, S3 backends, and output configurations. 💡

## What This Project Does 🌐

This Terraform project provisions a complete cloud infrastructure setup on AWS, focusing on network components, EC2 instances, and load balancing. The key components include:

1. **Networking Configuration:**
   - Creates a Virtual Private Cloud (VPC) with two subnets: one in `ap-south-1a` and another in `ap-south-1b`.
   - Configures an Internet Gateway to provide internet access to the VPC.
   - Establishes a route table with routes directing traffic through the Internet Gateway.
   - Associates the route table with both subnets, enabling external connectivity.

2. **Security Groups:**
   - Defines a security group allowing HTTP (port 80) and SSH (port 22) access to EC2 instances.
   - Configures egress rules to permit outbound traffic.

3. **EC2 Instances:**
   - Launches two EC2 instances in separate subnets using a specified AMI and instance type.
   - Associates the security group with the instances to control access.
   - Executes user data scripts (`userdata.sh` and `userdata1.sh`) to configure instance behavior.

4. **Load Balancer and Target Groups:**
   - Deploys an Application Load Balancer (ALB) across both subnets.
   - Creates a target group to route incoming traffic to both EC2 instances.
   - Configures a listener on port 80 to forward traffic to the target group.

5. **Outputs:**
   - Extracts essential outputs, such as public IPs of the EC2 instances and ALB DNS name, for easy access and verification.



## Project Structure

```
├── main.tf           # Main Terraform configuration file for resource definition
├── variables.tf      # Variable declarations for parameterization
├── backend.tf        # Remote backend configuration (e.g., S3, DynamoDB)
├── outputs.tf        # Outputs for referencing resource attributes
├── terraform.tfvars  # Variables specific to the environment
├── provider.tf       # Cloud provider configuration
├── README.md         # Project documentation
```

## What I Did and Why 🔍

- Provisioned a Virtual Private Cloud (VPC) with public and private subnets.
- Configured Security Groups to control access to resources.
- Deployed EC2 instances with specified AMI and instance types.
- Configured S3 bucket as the remote backend for Terraform state management.
- Implemented Terraform modules to organize resources and enable reusability.
- Managed sensitive data using environment variables.
- Output important resource information, such as public IPs and instance IDs.

### Changes I Made Apart from the Original Project 🛠️

1. **Backend Transition:**
   - Migrated state management from local storage to S3 using `backend.tf`. This was to gain experience in implementing remote backends and maintaining state files in a centralized, accessible location.

2. **Outputs Separation:**
   - Originally, output configurations were embedded in main.tf. I created outputs.tf to handle output values like instance public IP and key name separately, enhancing modularity and organization.

3. **Variable Management:**
   - Implemented terraform.tfvars to handle parameters such as AMI ID, instance type, and key name. This practice promotes reusability and simplifies configuration changes.

4. **EC2 Key Name Addition:**
   - Added key_name parameter to the EC2 instance configuration to practice SSH key management and secure access.

### Why DynamoDB Is Not Included
DynamoDB is commonly used for state locking to prevent concurrent state file modifications. However, to avoid additional costs, it was not implemented in this project. While concurrency risks exist, the focus remained on basic S3 state management.

### Prerequisites
Before running this project, ensure the following tools are installed:
- **Terraform** (latest version)
- **AWS CLI** (configured with appropriate credentials)
- **Access to an AWS S3 bucket** (for state file storage)

### Setup and Usage Instructions
1. **Configure AWS CLI:**
   ```bash
   aws configure
   ```

2. **Edit `terraform.tfvars`:**
   - Update the variables with appropriate values (e.g., AMI ID, instance type).

3. **Initialize the Project:**
   ```bash
   terraform init
   ```

4. **Apply S3 Configuration:**
   ```bash
   terraform apply -target=aws_s3_bucket.example
   ```

5. **Deploy the Infrastructure:**
   ```bash
   terraform apply
   ```

### Technologies and Tools Used
- **Terraform:** Infrastructure as Code (IaC) tool for resource provisioning.
- **AWS S3:** Remote backend storage for Terraform state files.
- **AWS EC2:** Compute instances managed via Terraform.

### Outputs and Verification
After applying the Terraform configurations, verify the following outputs:
- **Public IP:** Access the EC2 instance using the public IP displayed in the output.
- **Key Name:** Verify the SSH key used to connect to the EC2 instance.

### Learning Experience and Reflections 🌟
This project provided hands-on experience in implementing core Terraform concepts such as state management, parameterization using variables, and SSH key management. The use of S3 as a remote backend was particularly beneficial in understanding state persistence and resource tracking.

### Problems I Faced and Solutions
1. **Incorrect Syntax in Route Block:**
   - I typed the route block contained an `=` sign, causing an error:
   ```hcl
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }
   ```
   - Solution: Removed the `=` sign to resolve the error.

2. **Missing `.id` in Subnet Resource:**
   - Forgot to append `.id` to the subnet resource, causing reference issues.
   - Solution: Corrected the syntax by appending `.id` to the subnet resource.

3. **IMDSv1 to IMDSv2 Update:**
   - The original command to retrieve the instance ID used IMDSv1, which is deprecated. The updated command is:
   ```bash
   TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
   INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
   ```
