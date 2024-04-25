#creating an rds resource with password managed by aws secret manager that uses the default kms key for encryption
resource "aws_db_instance" "rds-database" {
  allocated_storage           = 10
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  manage_master_user_password = true
  username                    = "admin"
  parameter_group_name        = "default.mysql5.7"
  skip_final_snapshot         = true
}