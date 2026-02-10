Alibaba Cloud MSE SchedulerX Distributed Task Scheduling Terraform Module

================================================ 

# terraform-alicloud-mse-schedulerx

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-mse-schedulerx/blob/main/README-CN.md)

This Terraform module creates a complete MSE SchedulerX distributed task scheduling solution on Alibaba Cloud. It implements the [Quick Integration Of Distributed Task Scheduling](https://www.aliyun.com/solution/tech-solution/mse-schedulerx) solution, which involves the creation and deployment of resources such as Virtual Private Cloud (VPC), Virtual Switch (VSwitch), RDS Database (RDS), Elastic Compute Service (ECS), and automatic deployment of the SchedulerX demo application.

## Usage

This module creates a complete distributed task scheduling infrastructure including VPC network, ECS instances, RDS MySQL database, and automatically deploys the SchedulerX demo application.

```terraform
data "alicloud_instance_types" "default" {
  instance_type_family = "ecs.g7"
  sorted_by            = "CPU"
}

data "alicloud_images" "default" {
  name_regex    = "^aliyun_3_9_x64_20G_*"
  most_recent   = true
  owners        = "system"
  instance_type = data.alicloud_instance_types.default.ids[0]
}

module "schedulerx" {
  source = "alibabacloud-automation/mse-schedulerx/alicloud"

  vpc_config = {
    vpc_name   = "my-schedulerx-vpc"
    cidr_block = "192.168.0.0/16"
  }

  vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    vswitch_name = "my-schedulerx-vswitch"
  }

  instance_config = {
    count                      = 2
    instance_name              = "my-schedulerx-ecs"
    instance_type              = data.alicloud_instance_types.default.ids[0]
    image_id                   = data.alicloud_images.default.images[0].id
    password                   = "YourSecurePassword123!"
  }

  rds_account_config = {
    account_name     = "schedulerx_user"
    account_password = "YourDBPassword123!"
  }

  schedulerx_config = {
    app_key = "your-schedulerx-app-key"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-mse-schedulerx/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_db_instance.rds](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_instance) | resource |
| [alicloud_ecs_command.deployment_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.deployment_invocation](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instances](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_rds_account.rds_account](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rds_account) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_account.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/account) | data source |
| [alicloud_regions.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_deployment_script"></a> [custom\_deployment\_script](#input\_custom\_deployment\_script) | Custom deployment script for SchedulerX application. If not provided, the default script will be used. | `string` | `null` | no |
| <a name="input_demo_config"></a> [demo\_config](#input\_demo\_config) | Configuration for demo application user. | <pre>object({<br/>    user_name     = optional(string, "demo-user-example")<br/>    user_password = optional(string, "Demo123..")<br/>  })</pre> | `{}` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | Configuration for ECS command. | <pre>object({<br/>    name        = optional(string, "schedulerx-deploy")<br/>    type        = optional(string, "RunShellScript")<br/>    working_dir = optional(string, "/root")<br/>    timeout     = optional(number, 300)<br/>  })</pre> | `{}` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Map of ECS instances configuration. Each instance requires 'instance\_type', 'image\_id', and 'password'. | <pre>map(object({<br/>    instance_name              = optional(string, "schedulerx-ecs")<br/>    instance_type              = string<br/>    image_id                   = string<br/>    system_disk_category       = optional(string, "cloud_essd")<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>    password                   = string<br/>  }))</pre> | <pre>{<br/>  "instance1": {<br/>    "image_id": null,<br/>    "instance_type": null,<br/>    "password": null<br/>  },<br/>  "instance2": {<br/>    "image_id": null,<br/>    "instance_type": null,<br/>    "password": null<br/>  }<br/>}</pre> | no |
| <a name="input_rds_account_config"></a> [rds\_account\_config](#input\_rds\_account\_config) | Configuration for RDS account. The attributes 'account\_name' and 'account\_password' are required. | <pre>object({<br/>    account_name     = string<br/>    account_password = string<br/>    account_type     = optional(string, "Super")<br/>  })</pre> | <pre>{<br/>  "account_name": null,<br/>  "account_password": null<br/>}</pre> | no |
| <a name="input_rds_config"></a> [rds\_config](#input\_rds\_config) | Configuration for RDS MySQL instance. The attribute 'instance\_type' is required. | <pre>object({<br/>    instance_type    = string<br/>    instance_storage = optional(number, 40)<br/>    security_ips     = optional(list(string), ["192.168.0.0/24"])<br/>  })</pre> | <pre>{<br/>  "instance_type": null<br/>}</pre> | no |
| <a name="input_schedulerx_config"></a> [schedulerx\_config](#input\_schedulerx\_config) | Configuration for SchedulerX. The attribute 'app\_key' is required. | <pre>object({<br/>    endpoint  = optional(string, "addr-hz-internal.edas.aliyun.com")<br/>    namespace = optional(string, "00000000-00000000-00000000-00000000")<br/>    group_id  = optional(string, "test")<br/>    app_key   = string<br/>  })</pre> | <pre>{<br/>  "app_key": null<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for Security Group. | <pre>object({<br/>    security_group_name = optional(string, "schedulerx-sg")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Map of security group rules configuration. | <pre>map(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    port_range  = string<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "80/80",<br/>    "type": "ingress"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    vpc_name   = optional(string, "schedulerx-vpc")<br/>    cidr_block = string<br/>  })</pre> | <pre>{<br/>  "cidr_block": null<br/>}</pre> | no |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | Configuration for VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, "schedulerx-vswitch")<br/>  })</pre> | <pre>{<br/>  "cidr_block": null,<br/>  "zone_id": null<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_demo_url"></a> [demo\_url](#output\_demo\_url) | The URL to access the SchedulerX demo application |
| <a name="output_demo_username"></a> [demo\_username](#output\_demo\_username) | The username for accessing the demo application |
| <a name="output_ecs_instance_ids"></a> [ecs\_instance\_ids](#output\_ecs\_instance\_ids) | The IDs of the ECS instances |
| <a name="output_ecs_instance_public_ips"></a> [ecs\_instance\_public\_ips](#output\_ecs\_instance\_public\_ips) | The public IP addresses of the ECS instances |
| <a name="output_rds_account_name"></a> [rds\_account\_name](#output\_rds\_account\_name) | The name of the RDS account |
| <a name="output_rds_connection_string"></a> [rds\_connection\_string](#output\_rds\_connection\_string) | The connection string of the RDS instance |
| <a name="output_rds_instance_id"></a> [rds\_instance\_id](#output\_rds\_instance\_id) | The ID of the RDS instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the Security Group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The availability zone ID where resources are deployed |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)