# MSE SchedulerX Complete Example

This example demonstrates how to use the MSE SchedulerX module to deploy a complete distributed task scheduling solution.

## Overview

This example creates:
- A VPC and VSwitch for network isolation
- A security group with HTTP access rules
- Two ECS instances for the application
- An RDS MySQL database for data storage
- An RDS account for database access
- ECS commands for automatic deployment
- SchedulerX configuration for distributed task scheduling

## Prerequisites

1. You need to have SchedulerX service enabled in your Alibaba Cloud account
2. Obtain the following information from the SchedulerX console:
   - Namespace
   - Group ID (Application ID)
   - App Key (Application Key)

## Usage

1. Set the required variables in a `terraform.tfvars` file:

```hcl
ecs_instance_password = "YourSecurePassword123!"
rds_account_password  = "YourDBPassword123!"
schedulerx_app_key    = "your-schedulerx-app-key"
schedulerx_namespace  = "your-schedulerx-namespace"
schedulerx_group_id   = "your-schedulerx-group-id"
```

2. Initialize and apply the configuration:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Accessing the Demo Application

After deployment, you can access the SchedulerX demo application using the URL provided in the `demo_url` output. Use the credentials specified in the `demo_config` variables.

## Customization

You can customize the deployment by:
- Modifying the VPC and VSwitch CIDR blocks
- Changing the ECS instance count and specifications
- Adjusting the RDS instance storage size
- Providing a custom deployment script

## Clean Up

To destroy the resources:

```bash
$ terraform destroy
```

**Note:** This example will create resources that incur costs. Make sure to destroy the resources when you're done testing to avoid unnecessary charges.

## Notes

- The deployment script will automatically install and configure the SchedulerX demo application
- The ECS instances will be accessible via HTTP on port 80
- The RDS instance is configured with basic settings suitable for testing
- Make sure to use strong passwords for production deployments