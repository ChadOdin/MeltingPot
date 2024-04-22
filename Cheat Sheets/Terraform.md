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
  ami = "ami-0c55b159cbfafe1f0"

  # Instance Type determines the computing capacity and performance characteristics of the instance.
  instance_type = "t2.micro"
}

### Variables

# Define variables to parameterize the configuration and make it reusable.
variable "region" {
  default = "us-west-2"
}
```

- **AMI (Amazon Machine Image):** The AMI specifies the operating system and software installed on the instance. It provides the basis for the instance's root volume. Users can choose from a variety of pre-configured AMIs provided by AWS or create custom ones.
  
- **Instance Type:** The instance type determines the computing capacity and performance characteristics of the instance, such as CPU, memory, storage, and network performance. Different instance types are optimized for various workloads and use cases. For example, `t2.micro` is a general-purpose instance type suitable for low to moderate traffic applications.

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