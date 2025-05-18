#################################
# Servicio: Frontend
#################################

# Task Definition
resource "aws_ecs_task_definition" "task_frontend" {
  family                   = "frontend"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "850"
  memory                   = "850"
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name  = var.frontend_container_name
      image = var.frontend_image
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PUBLIC_API_URL"
          value = "http://${var.lb_dns_name}:8080"
        },
        {
          name  = "PUBLIC_API_KEY"
          value = "${var.public_api_key}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/frontend"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [container_definitions]
  }
}

# Service
resource "aws_ecs_service" "service_frontend" {
  name            = "frontend-service"
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_frontend.arn
  desired_count   = var.desired_count

  launch_type = "EC2"

  load_balancer {
    target_group_arn = var.target_group_frontend_arn
    container_name   = var.frontend_container_name
    container_port   = 3000
  }

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [data.aws_security_group.default.id, var.frontend_sg_id]
  }

  deployment_controller {
    type = "ECS"
  }

  scheduling_strategy = "REPLICA"

  health_check_grace_period_seconds = 30
  force_new_deployment              = true

  depends_on = [
    aws_ecs_task_definition.task_frontend,
    var.listener_frontend_arn
  ]
}

#################################
# Local variables
#################################

variable "ami_id" {
  default = "ami-03b4de1e633ccdc0f"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "vockey"
}

variable "user_data" {
  default = "IyEvYmluL2Jhc2ggCmVjaG8gRUNTX0NMVVNURVI9Q2x1c3Rlcl9BcGlfMSA+PiAvZXRjL2Vjcy9lY3MuY29uZmlnOw=="
}

variable "iam_instance_profile" {
  default = "LabInstanceProfile"
}

variable "frontend_container_name" {
  default = "gtio_votacion-frontend"
}

#################################
# Data from AWS
#################################

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "zone" {
  id = data.aws_subnets.default.ids[0]
}

#################################
# Tfvars variables
#################################

variable "frontend_image" { # igual se puede dinamizar
  description = "Imagen del frontend"
  type        = string
}

variable "lb_dns_name" {
  description = "Nombre DNS del Load Balancer"
  type        = string
}

variable "frontend_sg_id" {
  description = "ID del grupo de seguridad de frontend"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ARN del cluster ECS"
  type        = string
}

variable "target_group_frontend_arn" {
  description = "ARN del target group del frontend"
  type        = string
}

variable "listener_frontend_arn" {
  description = "ARN del listener del frontend"
  type        = string
}

variable "desired_count" {
  description = "Número deseado de instancias"
  type        = number
  default     = 1
}

variable "public_api_key" {
  description = "API key pública"
  type        = string  
}

###################################
# Outputs
###################################

output "ecs_service_name_frontend" {
  value       = aws_ecs_service.service_frontend.name
  description = "Nombre del servicio ECS del frontend"
}
