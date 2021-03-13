# RDS DB Instance
resource "aws_db_instance" "rds_instance" {
 lifecycle {
  ignore_changes = [
     "username",
     "password",
    ]
  }
  
  allocated_storage = 10
  storage_type = "gp2"
  engine = var.db_engine
  engine_version = var.engine_version
  instance_class = var.db_instance_class
  identifier = var.db_identifier
  name = var.db_name
  username = var.db_username
  password = var.db_password
  availability_zone = var.aws_region}a"
  vpc_security_group_ids = var.rds_sg_id
  skip_final_snapshot = var.db_skip_final_snapshot
  backup_retention_period = var.db_backup_retention_period
  db_subnet_group_name = var.rds_subnet_name
  tags = {
    Description   = var.description
    ManagedBy     = "Terraform"
  }
  provisioner "local-exec" {
    command = "mysql --host=${self.address} --port=${self.port} --user=${self.username} --password=${self.password} < ./schema.sql"
    }
  }
}
