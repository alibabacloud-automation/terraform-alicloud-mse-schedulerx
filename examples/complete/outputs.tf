output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.schedulerx.vpc_id
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = module.schedulerx.vswitch_id
}

output "security_group_id" {
  description = "The ID of the Security Group"
  value       = module.schedulerx.security_group_id
}

output "ecs_instance_ids" {
  description = "The IDs of the ECS instances"
  value       = module.schedulerx.ecs_instance_ids
}

output "ecs_instance_public_ips" {
  description = "The public IP addresses of the ECS instances"
  value       = module.schedulerx.ecs_instance_public_ips
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.schedulerx.rds_instance_id
}

output "rds_connection_string" {
  description = "The connection string of the RDS instance"
  value       = module.schedulerx.rds_connection_string
}

output "demo_url" {
  description = "The URL to access the SchedulerX demo application"
  value       = module.schedulerx.demo_url
}

output "demo_username" {
  description = "The username for accessing the demo application"
  value       = module.schedulerx.demo_username
}

output "zone_id" {
  description = "The availability zone ID where resources are deployed"
  value       = module.schedulerx.zone_id
}