locals {
  db_password = coalesce(var.db_master_password, random_password.db_master.result)
}
