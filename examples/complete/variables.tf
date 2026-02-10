variable "ecs_instance_password" {
  description = "Password for ECS instances. Must be 8-30 characters long and contain uppercase letters, lowercase letters, numbers, and special characters."
  type        = string
  sensitive   = true
  default     = "YourPassword123!" # Example value, replace with secure password in production
}

variable "rds_account_name" {
  description = "Name of the RDS account. Must be 2-32 characters long and start with a letter."
  type        = string
  default     = "schedulerx_user_example"
}

variable "rds_account_password" {
  description = "Password for RDS account. Must be 8-32 characters long and contain uppercase letters, lowercase letters, numbers, and special characters."
  type        = string
  sensitive   = true
  default     = "YourRDSPassword123!" # Example value, replace with secure password in production
}

variable "schedulerx_namespace" {
  description = "SchedulerX namespace. Please enter the namespace obtained from the SchedulerX console access configuration."
  type        = string
  default     = "00000000-00000000-00000000-00000000"
}

variable "schedulerx_group_id" {
  description = "SchedulerX application ID. Please enter the application ID obtained from the SchedulerX console access configuration."
  type        = string
  default     = "test"
}

variable "schedulerx_app_key" {
  description = "SchedulerX application key. Please enter the application key obtained from the SchedulerX console access configuration."
  type        = string
  sensitive   = true
  default     = "your-schedulerx-app-key" # Example value, replace with actual app key in production
}

variable "demo_user_name" {
  description = "Username for accessing the demo application in the browser."
  type        = string
  default     = "demo-user-example"
}

variable "demo_user_password" {
  description = "Password for accessing the demo application. Must be 8-32 characters long and contain uppercase letters, lowercase letters, numbers, and special characters."
  type        = string
  default     = "Demo123.."
}