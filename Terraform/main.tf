# Execute:
# terraform plan -out=tfplan -var-file=env.tfvars
# terraform apply tfplan
# terraform destroy -target=module.aws -var-file=env.tfvars

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = var.region
}

module "ecr" {
    source = "./modules/ecr"
}

module "aws" {
    source = "./modules/aws"
    kms_key_id = var.kms_key_id
    task_api_secret = var.task_api_secret
    api_image = var.api_image
    sql_password = var.sql_password
    frontend_image = var.frontend_image
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

variable "task_api_secret" { # igual se puede poner en el tfvars en vez de ser un secret de AWS
  description = "ARN del secreto de la API"
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

# variable "db_init_image" {
#   description = "Imagen para inicializar la base de datos"
#   type        = string
# }