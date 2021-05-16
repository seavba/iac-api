resource "aws_ecs_cluster" "elixir_ecs_cluster" {
  name = "elixir_ecs_cluster" # Naming the cluster
  tags = local.tags
}

resource "aws_ecs_task_definition" "elixir_ecs_task" {
  family                   = "elixir_ecs_task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "elixir_ecs_task",
      "image": "${var.ecr_repo_url}/${var.ecr_repo}:${var.ecr_image_tag}",
      "essential": true,
      "environment": [
        {
            "name": "ENDPOINT",
            "value": "${element(split(":", aws_db_instance.elixirDB.endpoint), 0)}"
        },
        {
            "name": "USERNAME",
            "value": "${var.elixirDB_rds_user}"
        },
        {
            "name": "PASSWORD",
            "value": "${var.elixirDB_rds_pass}"
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${var.cloudwatch_group}",
            "awslogs-region": "${var.aws_region}",
            "awslogs-stream-prefix": "ecs"
          }
        },
      "portMappings": [
        {
          "containerPort": 4000,
          "hostPort": 4000
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 2048         # Specifying the memory our container requires
  cpu                      = 1024         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  tags = local.tags
}

resource "aws_ecs_service" "elixir_service" {
  name                              = "elixir_service"                             # Naming our first service
  cluster                           = "${aws_ecs_cluster.elixir_ecs_cluster.id}"             # Referencing our created Cluster
  task_definition                   = "${aws_ecs_task_definition.elixir_ecs_task.arn}" # Referencing the task our service will spin up
  launch_type                       = "FARGATE"
  desired_count                     = var.num_containers # Setting the number of containers we want deployed to X
  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn                = "${aws_lb_target_group.elixirTG.arn}" # Referencing our target group
    container_name                  = "${aws_ecs_task_definition.elixir_ecs_task.family}"
    container_port                  = 4000 # Specifying the container port
  }

  network_configuration {
    subnets                         = aws_subnet.private.*.id
    assign_public_ip                = true
    security_groups                 = ["${aws_security_group.service_security_group.id}","${aws_security_group.rds.id}"]
  }
  tags = local.tags
}

resource "aws_cloudwatch_log_group" "elixirCW" {
  name = var.cloudwatch_group
  tags = local.tags
}
