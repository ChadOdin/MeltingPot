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

```hcl
# Create Resource: Defines a resource block to create an AWS instance with specified attributes.
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

# Variables: Defines a variable for the Terraform configuration.
variable "region" {
  default = "us-west-2"
}

# Output Values: Defines an output to display the public IP of the AWS instance.
output "instance_ip" {
  value = aws_instance.example.public_ip
}

# Modules: Defines a module to encapsulate reusable configurations.
module "vpc" {
  source = "./vpc"
}
```

## Commands <a name="commands"></a>

```bash
# Show Resource State: Displays the current state of resources managed by Terraform.

terraform show

## Example <a name="example"></a>

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