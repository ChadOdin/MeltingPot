## Table of Contents

- [Basics](#basics)
- [Configuration](#configuration)
- [Commands](#commands)
- [Example](#example)

## Basics <a name="basics"></a>

```bash
# Initialize Terraform: Initializes a Terraform working directory containing Terraform configuration files.

terraform init

# Plan Changes: Generates an execution plan, showing what actions Terraform will take to change infrastructure.

terraform plan

# Apply Changes: Applies the changes required to reach the desired state of the configuration.

terraform apply

# Destroy Infrastructure: Destroys the Terraform-managed infrastructure.

terraform destroy

```

## Configuration <a name="configuration"></a>

Terraform configuration is written in HashiCorp Configuration Language (HCL). It defines the desired state of infrastructure resources. Below are some key elements of Terraform configuration:

```hcl
### Resource Blocks

# Define the infrastructure resources to be managed by Terraform.
resource "aws_instance" "example" {
  # AMI (Amazon Machine Image) specifies the operating system and software installed on the instance.
  # Choose the appropriate AMI for your use case. You can find the latest AMI IDs in the AWS Console.
  ami = "ami-0c55b159cbfafe1f0"  # Ubuntu 18.04 LTS

  # Instance Type determines the computing capacity and performance characteristics of the instance.
  # Choose the appropriate instance type based on your application's requirements.
  instance_type = "t2.micro"
}

### Variables

# Define variables to parameterize the configuration and make it reusable.
variable "region" {
  default = "us-west-2"
}
```

In this example:

- **AMI (Amazon Machine Image):** The AMI specifies the operating system and software installed on the instance. You can choose the appropriate AMI for your use case. Common examples include:

    - `ami-0c55b159cbfafe1f0`: Ubuntu 18.04 LTS
    - `ami-0c1a7f89451184c8b`: Amazon Linux 2
    - `ami-052c08d70def0ac62`: CentOS 7
    - `ami-09e67e426f25ce0d7`: Red Hat Enterprise Linux 8

- **Instance Type:** The instance type determines the computing capacity and performance characteristics of the instance. You can choose the appropriate instance type based on your application's requirements. Common examples include:

    - `t2.micro`: General-purpose, suitable for low to moderate traffic applications.
    - `t3.medium`: Burstable performance, suitable for small to medium-sized applications.
    - `m5.large`: Balanced compute, memory, and network resources, suitable for a wide range of applications.
    - `c5.large`: Compute-optimized, suitable for compute-intensive applications.

## Commands <a name="commands"></a>

```bash
# Show Resource State: Displays the current state of resources managed by Terraform.

terraform show

## Example <a name="example"></a>
```
Suppose we want to provision an AWS EC2 instance using Terraform:

1. First, create a `main.tf` file with the following configuration:

    ```hcl
    provider "aws" {
      region = "us-west-2"
    }

    resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
    }

    output "instance_ip" {
      value = aws_instance.example.public_ip
    }
    ```

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Plan changes:

    ```bash
    terraform plan
    ```

4. Apply changes:

    ```bash
    terraform apply
    ```

5. After the instance is provisioned, you can view its public IP:

    ```bash
    terraform show
    ```

6. To destroy the infrastructure:

    ```bash
    terraform destroy
    ```