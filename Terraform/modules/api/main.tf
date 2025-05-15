#################################
# Servicio: Api Candidatos
#################################

# Task Definition
resource "aws_ecs_task_definition" "task_api_candidatos" {
  family                   = "api"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "850"
  memory                   = "850"
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name  = var.api_container_name
      image = var.api_image
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "CORS_ORIGIN"
          value = "http://${var.lb_dns_name}:3000"
        }
      ]
      secrets = [
        {
          name      = "ConnectionStrings__DefaultConnection"
          valueFrom = var.task_api_secret
        },
        {
          name      = "ConnectionStrings__MasterConnection"
          valueFrom = var.task_api_secret_master
        }
      ]
    }
  ])

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [container_definitions]
  }
}

# Service
resource "aws_ecs_service" "service_api_candidatos" {
  name            = "api-candidatos-service"
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_api_candidatos.arn
  desired_count   = 2

  launch_type = "EC2"

  load_balancer {
    target_group_arn = var.target_group_api_arn
    container_name   = var.api_container_name
    container_port   = 8080
  }

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [data.aws_security_group.default.id, var.rds_sg_id]
  }

  deployment_controller {
    type = "ECS"
  }

  scheduling_strategy = "REPLICA"

  health_check_grace_period_seconds = 30
  force_new_deployment              = true

  depends_on = [
    aws_ecs_task_definition.task_api_candidatos,
    var.listener_api_arn
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

variable "api_container_name" {
  default = "api-candidatos-container"
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

variable "task_api_secret" { # igual se puede poner en el tfvars en vez de ser un secret de AWS
  description = "ARN del secreto de la API"
  type        = string
}

variable "task_api_secret_master" { # igual se puede poner en el tfvars en vez de ser un secret de AWS
  description = "ARN del secreto de la API"
  type        = string
}

variable "api_image" { # igual se puede dinamizar
  description = "Imagen del contenedor de la API"
  type        = string
}

variable "lb_dns_name" {
  description = "Nombre DNS del Load Balancer"
  type        = string
}

variable "rds_sg_id" {
  description = "ID del grupo de seguridad de RDS"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ARN del cluster ECS"
  type        = string
}

variable "target_group_api_arn" {
  description = "ARN del target group de la API"
  type        = string
}

variable "listener_api_arn" {
  description = "ARN del listener de la API"
  type        = string
}

###################################
# Outputs
###################################

output "ecs_service_name_api" {
  value       = aws_ecs_service.service_api_candidatos.name
  description = "Nombre del servicio ECS de la API"
}
