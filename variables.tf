###############################################################################
# AWS VPC
###############################################################################

variable "aws_region" {
  default = "eu-west-1"
}


variable "azs" {
  default = "eu-west-1a,eu-west-1b,eu-west-1c"
}


variable "vpc_name" {
  default = "vpc_elixir"
}

variable "vpc_cdir" {
  default = "10.99.0.0/16"
}

variable "tg_group" {
  default = "/api/beers"
}


###############################################################################
# Elixir DB
###############################################################################
variable "elixirDB_rds_user" {
  default = "elixir"
}

variable "elixirDB_rds_pass" {
  default = "Barcelona2021#"
}

variable "elixirDB_rds_identifier" {
  default = "elixir"
}

variable "elixirDB_rds_target_port" {
  default = 5432
}

variable "elixirDB_rds_instance_class" {
  default = "db.t2.micro"
}

variable "elixirDB_rds_allocated_storage" {
  default = "10"
}

variable "elixirDB_rds_max_allocated_storage" {
  default = "15"
}

variable "elixirDB_rds_storage_type" {
  default = "gp2"
}

variable "elixirDB_rds_iops" {
  default = 0
}

variable "elixirDB_rds_engine" {
  default = "postgres"
}

variable "elixirDB_rds_engine_version" {
  default = "11.11"
}

variable "elixirDB_rds_family" {
  default = "postgres11"
}

variable "elixirDB_rds_allow_major_version_upgrade" {
  default = "false"
}

variable "elixirDB_rds_auto_minor_version_upgrade" {
  default = "false"
}

variable "elixirDB_rds_maintenance_window" {
  default = "Sat:03:00-Sat:06:00"
}

variable "elixirDB_rds_backup_retention_period" {
  default = "0"
}

variable "elixirDB_rds_iam_database_authentication_enabled" {
  default = true
}

variable "elixirDB_rds_create_monitoring_role" {
  default = true
}

variable "elixirDB_rds_monitoring_role_name" {
  default = "monit_rds_elixir"
}

variable "rds_multi_az" {
  default = "false"
}

variable "elixirDB_rds_copy_tags_to_snapshot" {
  default = "true"
}

variable "elixirDB_rds_deletion_protection" {
  default = false
}

variable "elixirDB_sec_group_name" {
  default = "elixir_rds_sec_group"
}

variable "elixirDB_rds_multi_az" {
  default = false
}

variable "elixirDB_rds_storage_encrypted" {
  default = false
}

variable "elixirDB_rds_skip_final_snapshot" {
  default = true
}

variable "elixirDB_rds_apply_immediately" {
  default = true
}

###############################################################################
# Elixir ECS
###############################################################################

variable "num_containers" {
  default = 1
}

variable "cloudwatch_group" {
  default = "elixirCW"
}

variable "ecr_image_tag" {
  default = "elixir-api"
}

variable "ecr_repo" {
  default = "elixir-images-repo"
}

variable "ecr_repo_url" {
  default = "077320249407.dkr.ecr.eu-west-1.amazonaws.com"
}
