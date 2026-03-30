variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "project_name" {
  type        = string
  description = "Prefix for resource names"
  default     = "mvp2-0"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Two public subnets, one per AZ"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  type        = list(string)
  description = "Private subnets for application VMs (2 per AZ)"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  type        = list(string)
  description = "Private subnets for RDS (2 per AZ; RDS subnet group needs 2 AZs)"
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_master_username" {
  type        = string
  default     = "dbadmin"
  description = "RDS master username"
  sensitive   = false
}

variable "db_master_password" {
  type        = string
  description = "Optional RDS password; if empty, a random password is generated"
  default     = null
  sensitive   = true
}
