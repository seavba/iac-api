resource "aws_vpc" "elixir_vpc" {
  cidr_block = var.vpc_cdir
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = local.tags
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.elixir_vpc.id}"
  count             = "${length(split(",", var.azs))}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  cidr_block        = "10.99.${count.index}.0/24"
  tags = local.tags
}


resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.elixir_vpc.id}"
  count             = "${length(split(",", var.azs))}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  cidr_block        = "10.99.${count.index + 3}.0/24"
  tags = local.tags
}

resource "aws_alb" "elixir_load_balancer" {
  name                 = "elixirLB"
  load_balancer_type   = "application"
  subnets              = aws_subnet.public.*.id
  security_groups      = ["${aws_security_group.load_balancer_security_group.id}"]
  tags                 = local.tags
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.elixir_vpc.id
  tags = local.tags
}

# Route the public subnet traffic through the IGW
resource "aws_route" "default" {
  route_table_id         = aws_vpc.elixir_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_lb_target_group" "elixirTG" {
  name        = "elixirTG"
  port        = 4000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_vpc.elixir_vpc.id}"
  health_check {
    matcher = "200,301,302"
    path = "${var.tg_group}"
    timeout = 120
    interval = 300
  }
  tags = local.tags
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn         = "${aws_alb.elixir_load_balancer.arn}"
  port                      = "80"
  protocol                  = "HTTP"
  default_action {
    type                    = "forward"
    target_group_arn        = "${aws_lb_target_group.elixirTG.arn}"
  }
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  name = "LB_security_group"
  vpc_id = "${aws_vpc.elixir_vpc.id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
  tags = local.tags
}

resource "aws_security_group" "service_security_group" {
  name = "service_security_group"
  vpc_id = "${aws_vpc.elixir_vpc.id}"
  ingress {
    from_port = 4000
    to_port   = 4000
    protocol  = "TCP"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
  tags = local.tags
}

resource "aws_db_subnet_group" "elixir_db_sub_g" {
  name       = "elixir_db_sub_g"
  subnet_ids = aws_subnet.private.*.id
  tags = local.tags
}

resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "RDS PGSQL server"
  vpc_id      = "${aws_vpc.elixir_vpc.id}"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.load_balancer_security_group.id}","${aws_security_group.service_security_group.id}"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
