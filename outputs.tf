output "alb_dns_name" {
  description = "Open in browser for nginx via load balancer"
  value       = aws_lb.main.dns_name
}

output "instance_ids" {
  value = {
    public_web   = aws_instance.public_web.id
    private_webs = { for az, instance in aws_instance.private_web : az => instance.id }
  }
}

output "rds_endpoint" {
  description = "MySQL endpoint (private only)"
  value       = aws_db_instance.main.address
}

output "rds_master_password" {
  description = "Effective RDS password (matches random_password when var not set)"
  value       = local.db_password
  sensitive   = true
}

output "rds_credentials_secret_arn" {
  description = "ARN of the Secrets Manager secret storing RDS master credentials"
  value       = aws_secretsmanager_secret.db_master_credentials.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}
