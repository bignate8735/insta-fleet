# ------------------------------------------------------------------------------
# RDS Subnet Group — Use private subnets only
# ------------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project}-rds-subnet-group"
  }
}