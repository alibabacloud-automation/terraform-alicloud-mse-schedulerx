output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "security_group_id" {
  description = "The ID of the Security Group"
  value       = alicloud_security_group.security_group.id
}

output "ecs_instance_ids" {
  description = "The IDs of the ECS instances"
  value       = [for instance in alicloud_instance.ecs_instances : instance.id]
}

output "ecs_instance_public_ips" {
  description = "The public IP addresses of the ECS instances"
  value       = [for instance in alicloud_instance.ecs_instances : instance.public_ip]
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = alicloud_db_instance.rds.id
}

output "rds_connection_string" {
  description = "The connection string of the RDS instance"
  value       = alicloud_db_instance.rds.connection_string
}

output "rds_account_name" {
  description = "The name of the RDS account"
  value       = alicloud_rds_account.rds_account.account_name
}

output "demo_url" {
  description = "The URL to access the SchedulerX demo application"
  value       = length(values(alicloud_instance.ecs_instances)) > 0 ? "http://${values(alicloud_instance.ecs_instances)[0].public_ip}/schedulerx-demo" : null
}

output "demo_username" {
  description = "The username for accessing the demo application"
  value       = var.demo_config.user_name
}

output "region_id" {
  description = "The region ID where resources are deployed"
  value       = local.region_id
}

output "zone_id" {
  description = "The availability zone ID where resources are deployed"
  value       = local.zone_id
}

output "account_id" {
  description = "The account ID where resources are deployed"
  value       = data.alicloud_account.current.id
}
