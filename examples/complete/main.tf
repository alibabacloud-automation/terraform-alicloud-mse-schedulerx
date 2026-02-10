provider "alicloud" {
  region = "cn-shenzhen"
}

# Query available instance types
data "alicloud_instance_types" "default" {
  instance_type_family = "ecs.g7"
  sorted_by            = "CPU"
}

# Query available images
data "alicloud_images" "default" {
  name_regex    = "^aliyun_3_9_x64_20G_*"
  most_recent   = true
  owners        = "system"
  instance_type = data.alicloud_instance_types.default.ids[0]
}

# Query available zones
data "alicloud_zones" "zones" {
  available_instance_type     = data.alicloud_instance_types.default.ids[0]
  available_resource_creation = "VSwitch"
}

module "schedulerx" {
  source = "../../"

  vpc_config = {
    vpc_name   = "schedulerx-example-vpc"
    cidr_block = "192.168.0.0/16"
  }

  vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = data.alicloud_zones.zones.ids[0]
    vswitch_name = "schedulerx-example-vswitch"
  }

  security_group_config = {
    security_group_name = "schedulerx-example-sg"
  }

  security_group_rules = {
    http_rule = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "192.168.0.0/24"
    }
  }

  instances = {
    instance1 = {
      instance_name              = "schedulerx-example-ecs-1"
      instance_type              = data.alicloud_instance_types.default.ids[0]
      image_id                   = data.alicloud_images.default.images[0].id
      system_disk_category       = "cloud_essd"
      internet_max_bandwidth_out = 5
      password                   = var.ecs_instance_password
    },
    instance2 = {
      instance_name              = "schedulerx-example-ecs-2"
      instance_type              = data.alicloud_instance_types.default.ids[0]
      image_id                   = data.alicloud_images.default.images[0].id
      system_disk_category       = "cloud_essd"
      internet_max_bandwidth_out = 5
      password                   = var.ecs_instance_password
    }
  }

  rds_config = {
    engine               = "MySQL"
    engine_version       = "8.0"
    instance_type        = "rds.mysql.t1.small"
    instance_storage     = 20
    instance_charge_type = "Postpaid"
    security_ips         = ["192.168.0.0/24"]
    vswitch_id           = null
  }

  rds_account_config = {
    account_name     = var.rds_account_name
    account_password = var.rds_account_password
    account_type     = "Super"
  }

  schedulerx_config = {
    endpoint  = "addr-hz-internal.edas.aliyun.com"
    namespace = var.schedulerx_namespace
    group_id  = var.schedulerx_group_id
    app_key   = var.schedulerx_app_key
  }

  demo_config = {
    user_name     = var.demo_user_name
    user_password = var.demo_user_password
  }

  ecs_command_config = {
    name        = "schedulerx-example-deploy"
    type        = "RunShellScript"
    working_dir = "/root"
    timeout     = 300
  }
}