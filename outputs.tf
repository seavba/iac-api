output "api_url" {
  value = "${aws_alb.elixir_load_balancer.dns_name}"
}

output "elixirDB_endpoint" {
  value = "${aws_db_instance.elixirDB.endpoint}"
}
