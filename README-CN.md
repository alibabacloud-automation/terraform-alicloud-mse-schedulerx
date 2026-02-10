阿里云 MSE SchedulerX 分布式任务调度 Terraform 模块

================================================ 

# terraform-alicloud-mse-schedulerx

[English](https://github.com/alibabacloud-automation/terraform-alicloud-mse-schedulerx/blob/main/README.md) | 简体中文

这个 Terraform 模块在阿里云上创建完整的 MSE SchedulerX 分布式任务调度解决方案。它实现了[快速集成分布式任务调度](https://www.aliyun.com/solution/tech-solution/mse-schedulerx)解决方案，涉及专有网络（VPC）、交换机（VSwitch）、RDS 数据库（RDS）、云服务器（ECS）等资源的创建和部署，以及 SchedulerX 演示应用程序的自动部署。

## 使用方法

此模块创建完整的分布式任务调度基础设施，包括 VPC 网络、ECS 实例、RDS MySQL 数据库，并自动部署 SchedulerX 演示应用程序。

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

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-mse-schedulerx/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
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