阿里云 MSE SchedulerX 分布式任务调度 Terraform 模块

# terraform-alicloud-mse-schedulerx

[English](https://github.com/alibabacloud-automation/terraform-alicloud-mse-schedulerx/blob/main/README.md) | 简体中文

这个 Terraform 模块在阿里云上创建完整的 MSE SchedulerX 分布式任务调度解决方案。它实现了[快速集成分布式任务调度](https://www.aliyun.com/solution/tech-solution/mse-schedulerx)解决方案，涉及专有网络（VPC）、交换机（VSwitch）、RDS 数据库（RDS）、云服务器（ECS）等资源的创建和部署，以及 SchedulerX 演示应用程序的自动部署。

## 使用方法

此模块创建完整的分布式任务调度基础设施，包括 VPC 网络、ECS 实例、RDS MySQL 数据库，并自动部署 SchedulerX 演示应用程序。

```terraform
data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

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
    zone_id      = data.alicloud_zones.default.zones[0].id
    vswitch_name = "my-schedulerx-vswitch"
  }

  instances = {
    instance1 = {
      instance_name = "my-schedulerx-ecs-1"
      instance_type = data.alicloud_instance_types.default.ids[0]
      image_id      = data.alicloud_images.default.images[0].id
      password      = "YourSecurePassword123!"
    }
    instance2 = {
      instance_name = "my-schedulerx-ecs-2"
      instance_type = data.alicloud_instance_types.default.ids[0]
      image_id      = data.alicloud_images.default.images[0].id
      password      = "YourSecurePassword123!"
    }
  }

  rds_config = {
    instance_type = "mysql.n2.small.2c"
  }

  rds_account_config = {
    account_name     = "schedulerx_user"
    account_password = "YourDBPassword123!"
  }

  schedulerx_config = {
    endpoint  = "addr-hz-internal.edas.aliyun.com"
    namespace = "00000000-00000000-00000000-00000000"
    group_id  = "test"
    app_key   = "your-schedulerx-app-key"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-mse-schedulerx/tree/main/examples/complete)

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
| <a name="input_instances"></a> [instances](#input\_instances) | Map of ECS instances configuration. Each instance requires 'instance\_type', 'image\_id', and 'password'. | <pre>map(object({<br/>    instance_name              = optional(string, "schedulerx-ecs")<br/>    instance_type              = string<br/>    image_id                   = string<br/>    system_disk_category       = optional(string, "cloud_essd")<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>    password                   = string<br/>  }))</pre> | n/a | yes |
| <a name="input_rds_account_config"></a> [rds\_account\_config](#input\_rds\_account\_config) | Configuration for RDS account. The attributes 'account\_name' and 'account\_password' are required. | <pre>object({<br/>    account_name     = string<br/>    account_password = string<br/>    account_type     = optional(string, "Super")<br/>  })</pre> | n/a | yes |
| <a name="input_rds_config"></a> [rds\_config](#input\_rds\_config) | Configuration for RDS MySQL instance. The attribute 'instance\_type' is required. | <pre>object({<br/>    engine               = optional(string, "MySQL")<br/>    engine_version       = optional(string, "8.0")<br/>    instance_type        = string<br/>    instance_storage     = optional(number, 40)<br/>    instance_charge_type = optional(string, "Postpaid")<br/>    security_ips         = optional(list(string), ["192.168.0.0/24"])<br/>  })</pre> | n/a | yes |
| <a name="input_schedulerx_config"></a> [schedulerx\_config](#input\_schedulerx\_config) | Configuration for SchedulerX. The attribute 'app\_key' is required. | <pre>object({<br/>    endpoint  = string<br/>    namespace = string<br/>    group_id  = string<br/>    app_key   = string<br/>  })</pre> | n/a | yes |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for Security Group. | <pre>object({<br/>    security_group_name = optional(string, "schedulerx-sg")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Map of security group rules configuration. | <pre>map(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    port_range  = string<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "80/80",<br/>    "type": "ingress"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    vpc_name   = optional(string, "schedulerx-vpc")<br/>    cidr_block = string<br/>  })</pre> | n/a | yes |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | Configuration for VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, "schedulerx-vswitch")<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The account ID where resources are deployed |
| <a name="output_demo_url"></a> [demo\_url](#output\_demo\_url) | The URL to access the SchedulerX demo application |
| <a name="output_demo_username"></a> [demo\_username](#output\_demo\_username) | The username for accessing the demo application |
| <a name="output_ecs_instance_ids"></a> [ecs\_instance\_ids](#output\_ecs\_instance\_ids) | The IDs of the ECS instances |
| <a name="output_ecs_instance_public_ips"></a> [ecs\_instance\_public\_ips](#output\_ecs\_instance\_public\_ips) | The public IP addresses of the ECS instances |
| <a name="output_rds_account_name"></a> [rds\_account\_name](#output\_rds\_account\_name) | The name of the RDS account |
| <a name="output_rds_connection_string"></a> [rds\_connection\_string](#output\_rds\_connection\_string) | The connection string of the RDS instance |
| <a name="output_rds_instance_id"></a> [rds\_instance\_id](#output\_rds\_instance\_id) | The ID of the RDS instance |
| <a name="output_region_id"></a> [region\_id](#output\_region\_id) | The region ID where resources are deployed |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the Security Group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The availability zone ID where resources are deployed |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)