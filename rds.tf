resource "aws_db_instance" "elixirDB" {
  identifier                          = var.elixirDB_rds_identifier
  engine                              = var.elixirDB_rds_engine
  engine_version                      = var.elixirDB_rds_engine_version
  port                                = var.elixirDB_rds_target_port
  instance_class                      = var.elixirDB_rds_instance_class
  allocated_storage                   = var.elixirDB_rds_allocated_storage
  max_allocated_storage               = var.elixirDB_rds_max_allocated_storage
  storage_type                        = var.elixirDB_rds_storage_type
  iops                                = var.elixirDB_rds_storage_type != "io1" ? 0 : var.elixirDB_rds_iops
  storage_encrypted                   = var.elixirDB_rds_storage_encrypted
  name                                = var.elixirDB_rds_identifier
  username                            = var.elixirDB_rds_user
  password                            = var.elixirDB_rds_pass
  multi_az                            = var.elixirDB_rds_multi_az
  iam_database_authentication_enabled = var.elixirDB_rds_iam_database_authentication_enabled
  maintenance_window                  = var.elixirDB_rds_maintenance_window
  backup_retention_period             = var.elixirDB_rds_backup_retention_period
  deletion_protection                 = var.elixirDB_rds_deletion_protection
  db_subnet_group_name                = "${aws_db_subnet_group.elixir_db_sub_g.name}"
  skip_final_snapshot                 = var.elixirDB_rds_skip_final_snapshot
  apply_immediately                   = var.elixirDB_rds_apply_immediately
  tags                                = local.tags
}
