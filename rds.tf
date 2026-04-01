resource "random_password" "db_master" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_master_credentials" {
  name        = "${var.environment}/${var.project_name}_${var.db_credentials_secret_name}"
  description = "RDS master credentials for ${var.project_name}"
}

resource "aws_secretsmanager_secret_version" "db_master_credentials" {
  secret_id = aws_secretsmanager_secret.db_master_credentials.id

  secret_string = jsonencode({
    username = var.db_master_username
    password = local.db_password
  })
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnets"
  subnet_ids = [for s in aws_subnet.private_db : s.id]

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

resource "aws_db_instance" "main" {
  identifier                 = "${var.project_name}-db"
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20
  storage_type               = "gp3"
  db_name                    = "appdb"
  username                   = var.db_master_username
  password                   = local.db_password
  db_subnet_group_name       = aws_db_subnet_group.main.name
  vpc_security_group_ids     = [aws_security_group.rds.id]
  multi_az                   = false
  availability_zone          = local.azs[0]
  skip_final_snapshot        = true
  publicly_accessible        = false
  backup_retention_period    = 0
  auto_minor_version_upgrade = true

  tags = { Name = "${var.project_name}-rds" }
}
