# ------------------------------------------------------------------------------
# RDS MySQL Instance
# ------------------------------------------------------------------------------
resource "aws_db_instance" "mysql" {
  identifier              = "${var.project}-mysql"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = var.mysql_version
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name

  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  multi_az                = false

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  tags = {
    Name = "${var.project}-rds"
  }
}