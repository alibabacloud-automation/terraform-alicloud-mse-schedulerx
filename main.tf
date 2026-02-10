data "alicloud_regions" "current" {}

data "alicloud_account" "current" {}

locals {
  # Default deployment script for SchedulerX application
  default_deployment_script = <<-SHELL
  #!/bin/bash

  function log_info() {
      printf "%s [INFO] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
  }

  function log_error() {
      printf "%s [ERROR] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
  }

  function debug_exec(){
      local cmd="$@"
      log_info "$cmd"
      eval "$cmd"
      ret=$?
      echo ""
      log_info "$cmd, exit code: $ret"
      return $ret
  }

  cat << EOF >> ~/.bash_profile
  export DEMO_SCHEDULERX_ENDPOINT="${var.schedulerx_config.endpoint}"
  export DEMO_SCHEDULERX_NAMESPACE="${var.schedulerx_config.namespace}"
  export DEMO_SCHEDULERX_GROUPID="${var.schedulerx_config.group_id}"
  export DEMO_SCHEDULERX_APPKEY="${var.schedulerx_config.app_key}"

  export DEMO_MYSQL_URL="${alicloud_db_instance.rds.connection_string}:3306"
  export DEMO_MYSQL_USERNAME="${var.rds_account_config.account_name}"
  export DEMO_MYSQL_PASSWORD="${var.rds_account_config.account_password}"

  export DEMO_USERNAME="${var.demo_config.user_name}"
  export DEMO_PASSWORD="${var.demo_config.user_password}"

  export ROS_DEPLOY=true
  EOF
  source ~/.bash_profile

  curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/mse-schedulerx/install.sh | bash
  SHELL

  region_id = data.alicloud_regions.current.regions[0].id
  zone_id   = var.vswitch_config.zone_id
}

# Create VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.vpc_config.vpc_name
  cidr_block = var.vpc_config.cidr_block
}

# Create VSwitch
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
}

# Create Security Group
resource "alicloud_security_group" "security_group" {
  security_group_name = var.security_group_config.security_group_name
  vpc_id              = alicloud_vpc.vpc.id
}

# Create Security Group Rules
resource "alicloud_security_group_rule" "rules" {
  for_each = var.security_group_rules

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  port_range        = each.value.port_range
  cidr_ip           = each.value.cidr_ip
  security_group_id = alicloud_security_group.security_group.id
}

# Create ECS instances
resource "alicloud_instance" "ecs_instances" {
  for_each = var.instances

  instance_name              = each.value.instance_name
  instance_type              = each.value.instance_type
  vswitch_id                 = alicloud_vswitch.vswitch.id
  security_groups            = [alicloud_security_group.security_group.id]
  image_id                   = each.value.image_id
  system_disk_category       = each.value.system_disk_category
  internet_max_bandwidth_out = each.value.internet_max_bandwidth_out
  password                   = each.value.password
}

# Create RDS MySQL instance
resource "alicloud_db_instance" "rds" {
  engine               = var.rds_config.engine
  engine_version       = var.rds_config.engine_version
  instance_type        = var.rds_config.instance_type
  instance_storage     = var.rds_config.instance_storage
  instance_charge_type = var.rds_config.instance_charge_type
  vswitch_id           = alicloud_vswitch.vswitch.id
  security_ips         = var.rds_config.security_ips
}

# Create RDS account
resource "alicloud_rds_account" "rds_account" {
  db_instance_id   = alicloud_db_instance.rds.id
  account_name     = var.rds_account_config.account_name
  account_password = var.rds_account_config.account_password
  account_type     = var.rds_account_config.account_type
}

# Create ECS command for deployment
resource "alicloud_ecs_command" "deployment_command" {
  name            = var.ecs_command_config.name
  type            = var.ecs_command_config.type
  command_content = var.custom_deployment_script != null ? var.custom_deployment_script : base64encode(local.default_deployment_script)
  working_dir     = var.ecs_command_config.working_dir
  timeout         = var.ecs_command_config.timeout
}

# Execute deployment command on ECS instances
resource "alicloud_ecs_invocation" "deployment_invocation" {
  instance_id = [for instance in alicloud_instance.ecs_instances : instance.id]
  command_id  = alicloud_ecs_command.deployment_command.id
  timeouts {
    create = "5m"
  }
  depends_on = [alicloud_rds_account.rds_account]
}