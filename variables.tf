variable "vpc_config" {
  description = "Configuration for VPC. The attribute 'cidr_block' is required."
  type = object({
    vpc_name   = optional(string, "schedulerx-vpc")
    cidr_block = string
  })
}

variable "vswitch_config" {
  description = "Configuration for VSwitch. The attributes 'cidr_block' and 'zone_id' are required."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, "schedulerx-vswitch")
  })
}

variable "security_group_config" {
  description = "Configuration for Security Group."
  type = object({
    security_group_name = optional(string, "schedulerx-sg")
  })
  default = {}
}

variable "security_group_rules" {
  description = "Map of security group rules configuration."
  type = map(object({
    type        = string
    ip_protocol = string
    port_range  = string
    cidr_ip     = string
  }))
  default = {
    http = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "0.0.0.0/0"
    }
  }
}

variable "instances" {
  description = "Map of ECS instances configuration. Each instance requires 'instance_type', 'image_id', and 'password'."
  type = map(object({
    instance_name              = optional(string, "schedulerx-ecs")
    instance_type              = string
    image_id                   = string
    system_disk_category       = optional(string, "cloud_essd")
    internet_max_bandwidth_out = optional(number, 5)
    password                   = string
  }))
}

variable "rds_config" {
  description = "Configuration for RDS MySQL instance. The attribute 'instance_type' is required."
  type = object({
    engine               = optional(string, "MySQL")
    engine_version       = optional(string, "8.0")
    instance_type        = string
    instance_storage     = optional(number, 40)
    instance_charge_type = optional(string, "Postpaid")
    security_ips         = optional(list(string), ["192.168.0.0/24"])
  })
}

variable "rds_account_config" {
  description = "Configuration for RDS account. The attributes 'account_name' and 'account_password' are required."
  type = object({
    account_name     = string
    account_password = string
    account_type     = optional(string, "Super")
  })
}

variable "schedulerx_config" {
  description = "Configuration for SchedulerX. The attribute 'app_key' is required."
  type = object({
    endpoint  = string
    namespace = string
    group_id  = string
    app_key   = string
  })
}

variable "demo_config" {
  description = "Configuration for demo application user."
  type = object({
    user_name     = optional(string, "demo-user-example")
    user_password = optional(string, "Demo123..")
  })
  default = {}

  validation {
    condition     = length(var.demo_config.user_password) >= 8
    error_message = "The demo user password must be at least 8 characters long and contain uppercase letters, lowercase letters, numbers, and special characters."
  }
}

variable "ecs_command_config" {
  description = "Configuration for ECS command."
  type = object({
    name        = optional(string, "schedulerx-deploy")
    type        = optional(string, "RunShellScript")
    working_dir = optional(string, "/root")
    timeout     = optional(number, 300)
  })
  default = {}
}

variable "custom_deployment_script" {
  description = "Custom deployment script for SchedulerX application. If not provided, the default script will be used."
  type        = string
  default     = null
}