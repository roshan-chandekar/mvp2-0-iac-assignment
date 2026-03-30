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

variable "environment" {
  type        = string
  description = "Environment name used for naming resources (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
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

variable "ssh_key_name" {
  type        = string
  description = "AWS EC2 Key Pair name to attach to instances (use the name that matches your dev.pem)"
  default     = "dev"
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "CIDR allowed to SSH to instances (port 22). Set to your public IP/32 for safer access."
  default     = "0.0.0.0/0"
}

variable "db_credentials_secret_name" {
  type        = string
  description = "Base name for the Secrets Manager secret storing RDS master credentials"
  default     = "rds-master-credentials"
  sensitive   = false
}
