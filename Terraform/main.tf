# Execute:
# terraform plan -out=tfplan -var-file=env.tfvars
# terraform apply tfplan
# terraform destroy -target=module.aws -var-file=env.tfvars

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  # S3 bucket
  backend "s3" {
    bucket       = "gtio-votacion-state2"
    key          = "terraform/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = false
    encrypt      = true
  }
}

provider "aws" {
  region = var.region
}

module "ecr" {
  source = "./modules/ecr"
}

module "infrastructure" {
  source          = "./modules/infrastructure"
  kms_key_id      = var.kms_key_id
  task_api_secret = var.task_api_secret
  api_image       = var.api_image
  sql_password    = var.sql_password
  frontend_image  = var.frontend_image
  api_key         = var.api_key
  desired_count   = var.desired_count
}

module "frontend" {
  source         = "./modules/frontend"
  frontend_image = var.frontend_image

  lb_dns_name               = module.infrastructure.lb_dns_name
  ecs_cluster_arn           = module.infrastructure.ecs_cluster_arn
  target_group_frontend_arn = module.infrastructure.target_group_frontend_arn
  listener_frontend_arn     = module.infrastructure.listener_frontend_arn
  frontend_sg_id            = module.infrastructure.frontend_sg_id
  desired_count             = var.desired_count
  public_api_key            = var.api_key
}

module "api" {
  source                 = "./modules/api"
  task_api_secret        = var.task_api_secret
  task_api_secret_master = var.task_api_secret_master
  api_image              = var.api_image
  lb_dns_name            = module.infrastructure.lb_dns_name
  ecs_cluster_arn        = module.infrastructure.ecs_cluster_arn
  target_group_api_arn   = module.infrastructure.target_group_api_arn
  listener_api_arn       = module.infrastructure.listener_api_arn
  api_sg_id              = module.infrastructure.api_sg_id
  desired_count          = var.desired_count
  public_api_key         = var.api_key
  admin_api_key          = var.admin_api_key
}

variable "region" {
  default = "us-east-1"
}

#################################
# Tfvars variables
#################################

variable "kms_key_id" { # igual se puede dinamizar
  description = "ARN de la clave KMS"
  type        = string
}

variable "task_api_secret" {
  description = "ARN del secreto de la API"
  type        = string
}

variable "task_api_secret_master" {
  description = "ARN del secreto de la API master"
  type        = string
}

variable "api_image" { # igual se puede dinamizar
  description = "Imagen del contenedor de la API"
  type        = string
}

variable "sql_password" {
  description = "Contraseña SQL"
  type        = string
  sensitive   = true
}

variable "frontend_image" { # igual se puede dinamizar
  description = "Imagen del frontend"
  type        = string
}

variable "api_key" {
  description = "API key"
  type        = string
}

variable "admin_api_key" {
  description = "API key"
  type        = string
}

variable "desired_count" {
  description = "Número deseado de instancias"
  type        = number
  default     = 2
}

################################
# Outputs
################################

output "ecs_cluster_name" {
  value = module.infrastructure.ecs_cluster_name
}

output "ecs_service_name_frontend" {
  value = module.frontend.ecs_service_name_frontend
}

output "ecs_service_name_api" {
  value = module.api.ecs_service_name_api
}