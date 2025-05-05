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
          valueFrom = var.task_api_secret
        }
      ]
    }
  ])

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    force_update = timestamp()
  }
}

# Service
resource "aws_ecs_service" "service_api_candidatos" {
  name            = "api-candidatos-service"
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_api_candidatos.arn
  desired_count   = 1

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

  lifecycle {
    replace_triggered_by = [
      aws_ecs_task_definition.task_api_candidatos,
    ]
  }

  depends_on = [
    aws_ecs_task_definition.task_api_candidatos,
    var.listener_api_arn
  ]
}

# Instance
resource "aws_instance" "ecs_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  availability_zone      = var.availability_zones[0]
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [data.aws_security_group.default.id, var.rds_sg_id]
  user_data              = var.user_data
  iam_instance_profile   = var.iam_instance_profile

  tags = {
    Name = "instancia-api-candidatos"
  }
}

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
  }

  tags = {
    force_update = timestamp()
  }
}

# Service
resource "aws_ecs_service" "service_frontend" {
  name            = "frontend-service2"
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_frontend.arn
  desired_count   = 1

  launch_type = "EC2"

  load_balancer {
    target_group_arn = var.target_group_frontend_arn
    container_name   = var.frontend_container_name
    container_port   = 3000
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

  lifecycle {
    replace_triggered_by = [
      aws_ecs_task_definition.task_frontend,
    ]
  }

  depends_on = [
    aws_ecs_task_definition.task_frontend,
    var.listener_frontend_arn
  ]
}

# Instance
resource "aws_instance" "ecs_instance_frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  availability_zone      = var.availability_zones[0]
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [data.aws_security_group.default.id, var.rds_sg_id]
  user_data              = var.user_data
  iam_instance_profile   = var.iam_instance_profile

  tags = {
    Name = "instancia-frontend"
  }
}

#################################
# Local variables
#################################

variable "availability_zones" {
  default = ["us-east-1b", "us-east-1b", "us-east-1c", "us-east-1a", "us-east-1e", "us-east-1f"]
}

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

#################################
# Tfvars variables
#################################

variable "task_api_secret" { # igual se puede poner en el tfvars en vez de ser un secret de AWS
  description = "ARN del secreto de la API"
  type        = string
}

variable "api_image" { # igual se puede dinamizar
  description = "Imagen del contenedor de la API"
  type        = string
}

variable "frontend_image" { # igual se puede dinamizar
  description = "Imagen del frontend"
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

variable "target_group_frontend_arn" {
  description = "ARN del target group del frontend"
  type        = string
}

variable "listener_api_arn" {
  description = "ARN del listener de la API"
  type        = string
}

variable "listener_frontend_arn" {
  description = "ARN del listener del frontend"
  type        = string
}
