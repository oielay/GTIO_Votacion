# Cluster de ECS
resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.cluster_name

    setting {
        name  = "containerInsights"
        value = "enabled"
    }

    tags = {
        Name = var.cluster_name
    }
}

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
            name      = var.api_container_name
            image     = var.api_image
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
                    value = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}:3000"
                }
            ]
            secrets = [
                {
                    name      = "ConnectionStrings__DefaultConnection"
                    valueFrom = var.task_api_secret
                }
            ]
        }
    ])
}

# Service
resource "aws_ecs_service" "service_api_candidatos" {
    name            = "api-candidatos-service"
    cluster         = aws_ecs_cluster.ecs_cluster.arn
    task_definition = aws_ecs_task_definition.task_api_candidatos.arn
    desired_count   = 1

    launch_type     = "EC2"

    load_balancer {
        target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup.arn
        container_name   = var.api_container_name
        container_port   = 8080
    }

    network_configuration {
        subnets          = data.aws_subnets.default.ids
        security_groups  = [data.aws_security_group.default.id, aws_security_group.rds_sg.id]
    }

    deployment_controller {
        type = "ECS"
    }

    scheduling_strategy = "REPLICA"

    health_check_grace_period_seconds = 30
    force_new_deployment = true

    depends_on = [
        aws_ecs_task_definition.task_api_candidatos,
        aws_lb_listener.ElasticLoadBalancingV2Listener
    ]
}

# Instance
resource "aws_instance" "ecs_instance" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    availability_zone      = var.availability_zones[0]
    subnet_id              = data.aws_subnets.default.ids[0]
    vpc_security_group_ids     = [data.aws_security_group.default.id, aws_security_group.rds_sg.id]
    user_data = var.user_data
    iam_instance_profile   = var.iam_instance_profile

    tags = {
        Name = "instancia-api-candidatos"
    }
}

# Load Balancer
resource "aws_lb" "ElasticLoadBalancingV2LoadBalancer" {
    name = "balanceador-candidatos"
    internal = false
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [
        data.aws_security_group.default.id,
        aws_security_group.rds_sg.id
    ]
    ip_address_type = "ipv4"
    access_logs {
        enabled = false
        bucket = ""
        prefix = ""
    }
    idle_timeout = "60"
    enable_deletion_protection = "false"
    enable_http2 = "true"
    enable_cross_zone_load_balancing = "true"
}

# Listener Api
resource "aws_lb_listener" "ElasticLoadBalancingV2Listener" {
    load_balancer_arn = aws_lb.ElasticLoadBalancingV2LoadBalancer.arn
    port = 8080
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup.arn
        type = "forward"
    }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "AutoScalingAutoScalingGroup" {
    name = var.autoscaling_group_name
    launch_template {
        id = aws_launch_template.EC2LaunchTemplate.id
        version = "1"
    }
    min_size = var.autoscaling_min_size
    max_size = var.autoscaling_max_size
    desired_capacity = var.autoscaling_desired_capacity
    default_cooldown = 300
    health_check_type = "EC2"
    health_check_grace_period = 0
    vpc_zone_identifier = data.aws_subnets.default.ids
    termination_policies = [
        "Default"
    ]
    service_linked_role_arn = data.aws_iam_role.autoscaling_role.arn
    tag {
        key = "AmazonECSManaged"
        value = ""
        propagate_at_launch = true
    }
    tag {
        key = "Name"
        value = "ECS Instance - Cluster_Api_1"
        propagate_at_launch = true
    }
}

# Launch Template
resource "aws_launch_template" "EC2LaunchTemplate" {
    name = var.launch_template_name
    user_data = var.user_data
    iam_instance_profile {
        arn = data.aws_iam_instance_profile.lab_profile.arn
    }
    key_name = var.key_name
    network_interfaces {
        associate_public_ip_address = true
        delete_on_termination = true
        device_index = 0
        security_groups = [
            data.aws_security_group.default.id,
            aws_security_group.rds_sg.id
        ]
    }
    image_id = var.ami_id
    instance_type = var.instance_type
}

# Target Group
resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
    health_check {
        interval = 30
        path = "/api/Candidates/Test"
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 5
        matcher = "200"
    }
    port = 8080
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = data.aws_vpc.default.id
    name = "grupo-apiCandidatos"
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
            name      = var.frontend_container_name
            image     = var.frontend_image
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
                    value = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}:8080"
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
}

# Log group
resource aws_cloudwatch_log_group "frontend_logs" {
    name              = "/ecs/frontend"
    retention_in_days = 7
}

# Service
resource "aws_ecs_service" "service_frontend" {
    name            = "frontend-service"
    cluster         = aws_ecs_cluster.ecs_cluster.arn
    task_definition = aws_ecs_task_definition.task_frontend.arn
    desired_count   = 1

    launch_type     = "EC2"

    load_balancer {
        target_group_arn = aws_lb_target_group.load_balancer_target_group_frontend.arn
        container_name   = var.frontend_container_name
        container_port   = 3000
    }

    network_configuration {
        subnets          = data.aws_subnets.default.ids
        security_groups  = [data.aws_security_group.default.id, aws_security_group.rds_sg.id]
    }

    deployment_controller {
        type = "ECS"
    }

    scheduling_strategy = "REPLICA"

    health_check_grace_period_seconds = 30
    force_new_deployment = true

    depends_on = [
        aws_ecs_task_definition.task_frontend,
        aws_lb_listener.load_balancer_listener_frontend
    ]
}

# Instance
resource "aws_instance" "ecs_instance_frontend" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    availability_zone      = var.availability_zones[0]
    subnet_id              = data.aws_subnets.default.ids[0]
    vpc_security_group_ids     = [data.aws_security_group.default.id, aws_security_group.rds_sg.id]
    user_data = var.user_data
    iam_instance_profile   = var.iam_instance_profile

    tags = {
        Name = "instancia-frontend"
    }
}

# Listener Frontend
resource "aws_lb_listener" "load_balancer_listener_frontend" {
    load_balancer_arn = aws_lb.ElasticLoadBalancingV2LoadBalancer.arn
    port = 3000
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.load_balancer_target_group_frontend.arn
        type = "forward"
    }
    depends_on = [ aws_lb_target_group.load_balancer_target_group_frontend ]
}

# Target Group Frontend
resource "aws_lb_target_group" "load_balancer_target_group_frontend" {
    health_check {
        interval = 30
        path = "/"
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 5
        matcher = "200-299"
    }
    port = 3000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = data.aws_vpc.default.id
    name = "grupo-front"
}

#################################
# Base de Datos: RDS SQL Server
#################################

# RDS
resource "aws_db_instance" "RDSDBInstance" {
    identifier = "sqlserver"
    allocated_storage = 20
    instance_class = "db.t3.micro"
    engine = "sqlserver-ex"
    username = "sa"
    password = var.sql_password
    backup_window = "07:41-08:11"
    backup_retention_period = 1
    availability_zone = var.availability_zones[1]
    maintenance_window = "sat:04:41-sat:05:11"
    multi_az = false
    engine_version = "15.00.4430.1.v1"
    auto_minor_version_upgrade = false
    license_model = "license-included"
    character_set_name = "SQL_Latin1_General_CP1_CI_AS"
    publicly_accessible = true
    storage_type = "gp2"
    port = 1433
    storage_encrypted = true
    kms_key_id = var.kms_key_id
    copy_tags_to_snapshot = true
    monitoring_interval = 0
    iam_database_authentication_enabled = false
    deletion_protection = false
    db_subnet_group_name = aws_db_subnet_group.db_subnet_gtio_votacion.name
    vpc_security_group_ids = [
        data.aws_security_group.default.id,
        aws_security_group.rds_sg.id
    ]
    skip_final_snapshot = true
}

resource "aws_db_subnet_group" "db_subnet_gtio_votacion" {
    name        = "db-subnet-gtio-votacion"
    description = "DB subnet group"
    subnet_ids  = data.aws_subnets.default.ids

    tags = {
        Name = "db-subnet-gtio-votacion"
    }
}

# resource "aws_ecs_task_definition" "db_init_task" {
#     family                   = "db-init-task"
#     requires_compatibilities = ["FARGATE"]
#     cpu                      = "256"
#     memory                   = "512"
#     network_mode             = "awsvpc"
#     execution_role_arn       = data.aws_iam_role.lab_role.arn
#     task_role_arn            = data.aws_iam_role.lab_role.arn

#     container_definitions = jsonencode([
#         {
#             name      = "db-init"
#             image     = var.db_init_image
#             essential = true
#             environment = [
#                 {
#                     name  = "DB_SERVER"
#                     value = var.db_server
#                 },
#                 {
#                     name  = "DB_USER"
#                     value = "sa"
#                 },
#                 {
#                     name  = "DB_PASSWORD"
#                     value = var.db_password
#                 }
#             ]
#             logConfiguration = {
#                 logDriver = "awslogs",
#                 options = {
#                     awslogs-group         = "/ecs/db-init"
#                     awslogs-region        = "us-east-1"
#                     awslogs-stream-prefix = "ecs"
#                 }
#             }
#         }
#     ])

#     depends_on = [
#         aws_db_instance.RDSDBInstance
#     ]
# }

# resource "aws_cloudwatch_log_group" "db_init_logs" {
#     name              = "/ecs/db-init"
#     retention_in_days = 7
# }

# resource "null_resource" "run_db_init_task" {
#     depends_on = [aws_db_instance.RDSDBInstance]

#     provisioner "local-exec" {
#         command = "aws ecs run-task --cluster ${aws_ecs_cluster.ecs_cluster.name} --launch-type FARGATE --network-configuration awsvpcConfiguration={subnets=[${join(",", formatlist("\"%s\"", data.aws_subnets.default.ids))}],securityGroups=[\"${data.aws_security_group.default.id}\"],assignPublicIp=\"ENABLED\"} --task-definition ${aws_ecs_task_definition.db_init_task.arn}"
#     }

#     triggers = {
#         always_run = timestamp()
#     }
# }

# resource "aws_ecs_service" "run_db_init" {
#     name = "db-init-service"
#     task_definition = aws_ecs_task_definition.db_init_task.arn
#     cluster         = aws_ecs_cluster.ecs_cluster.arn
#     launch_type     = "FARGATE"

#     network_configuration {
#         subnets          = data.aws_subnets.default.ids
#         security_groups  = [data.aws_security_group.default.id, aws_security_group.rds_sg.id]
#         assign_public_ip = true
#     }

#     depends_on = [aws_db_instance.RDSDBInstance, aws_ecs_task_definition.db_init_task]
#     desired_count   = 1
# }

resource "aws_security_group" "rds_sg" {
    name        = "rds-sql-access"
    description = "Allow SQL Server access"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        description      = "RDS SQL Server"
        from_port        = 1433
        to_port          = 1433
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "Frontend"
        from_port        = 3000
        to_port          = 3000
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "Api candidatos"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "RDS SQL Security Group"
    }
}

#################################
# Cloudwatch: eventos para despliegue automatico
#################################

# resource "aws_cloudwatch_event_rule" "api_image_push_rule" {
#     name        = "api-image-push-rule"
#     description = "Regla para activar eventos solo cuando se suba una nueva imagen al repositorio de api"
#     event_pattern = jsonencode({
#         "source" = [
#             "aws.ecr"
#         ],
#         "detail-type" = [
#             "ECR Image Action"
#         ],
#         "detail" = {
#             "action-type" = ["PUSH"]
#             "repository-name" = [aws_ecr_repository.api_repo.name]
#         }
#     })
# }

# resource "aws_cloudwatch_event_rule" "frontend_image_push_rule" {
#     name        = "frontend-image-push-rule"
#     description = "Regla para activar eventos solo cuando se suba una nueva imagen al repositorio de frontend"
#     event_pattern = jsonencode({
#         "source" = [
#             "aws.ecr"
#         ],
#         "detail-type" = [
#             "ECR Image Action"
#         ],
#         "detail" = {
#             "action-type" = ["PUSH"]
#             "repository-name" = [aws_ecr_repository.frontend_repo.name]
#         }
#     })
# }

# resource "aws_cloudwatch_event_target" "api_ecs_service_target" {
#     rule = aws_cloudwatch_event_rule.api_image_push_rule.name
#     arn  = aws_ecs_service.service_api_candidatos.id
#     role_arn = data.aws_iam_role.lab_role.arn

#     input = jsonencode({
#         "cluster"         = aws_ecs_cluster.ecs_cluster.name,
#         "service"         = aws_ecs_service.service_api_candidatos.name,
#         "desiredCount"    = 1,
#         "forceNewDeployment" = true
#     })
# }

# resource "aws_cloudwatch_event_target" "frontend_ecs_service_target" {
#     rule = aws_cloudwatch_event_rule.frontend_image_push_rule.name
#     arn  = aws_ecs_service.service_frontend.id
#     role_arn = data.aws_iam_role.lab_role.arn

#     input = jsonencode({
#         "cluster"         = aws_ecs_cluster.ecs_cluster.name,
#         "service"         = aws_ecs_service.service_frontend.name,
#         "desiredCount"    = 1,
#         "forceNewDeployment" = true
#     })
# }

# Ejecutar en local
# resource "null_resource" "run_sql_script" {
#     provisioner "local-exec" {
#         command = <<-EOF
#         sqlcmd -S ${aws_db_instance.RDSDBInstance.endpoint} -U sa -P ${var.sql_password} -d master -i "./scripts/init1.sql"
#         EOF
#     }

#     depends_on = [aws_db_instance.RDSDBInstance]
# }

# Lambda Function ---- NO FUNCIONA ADECUADAMENTE ----
# resource "aws_lambda_function" "db_creation_lambda" {
#     function_name = "db_creation_lambda"
#     role          = data.aws_iam_role.lab_role.arn
#     handler       = "lambda_function.lambda_handler"
#     runtime       = "python3.8"
    
#     filename      = "lambda_function.zip"
    
#     environment {
#         variables = {
#             DB_SERVER = aws_db_instance.RDSDBInstance.address
#             DB_USER   = "sa"
#             DB_PASSWORD = var.sql_password
#         }
#     }

#     vpc_config {
#         subnet_ids         = data.aws_subnets.default.ids
#         security_group_ids = [data.aws_security_group.default.id]
#     }
    
#     source_code_hash = filebase64sha256("lambda_function.zip")
# }

# resource "aws_cloudwatch_event_rule" "rds_event_rule" {
#     name        = "rds-instance-available-rule"
#     description = "Regla para ejecutar Lambda cuando RDS esté disponible"
#     event_pattern = jsonencode({
#         source = ["aws.rds"],
#         detail_type = ["RDS DB Instance Event"],
#         detail = {
#             "EventCategories" = ["Availability"]
#             "SourceType"      = ["DB_INSTANCE"]
#             "SourceIdentifier" = [aws_db_instance.RDSDBInstance.id]
#         }
#     })
# }

# resource "aws_cloudwatch_event_target" "lambda_target" {
#     rule      = aws_cloudwatch_event_rule.rds_event_rule.name
#     target_id = "lambdaTarget"
#     arn       = aws_lambda_function.db_creation_lambda.arn
# }

# resource "aws_lambda_permission" "allow_eventbridge_to_invoke_lambda" {
#     statement_id  = "AllowExecutionFromCloudWatch"
#     action        = "lambda:InvokeFunction"
#     function_name = aws_lambda_function.db_creation_lambda.function_name
#     principal     = "events.amazonaws.com"
#     source_arn    = aws_cloudwatch_event_rule.rds_event_rule.arn
# }

# resource "aws_ebs_volume" "EC2Volume" {
#     availability_zone = var.availability_zones[0]
#     encrypted = false
#     size = 30
#     type = "gp3"
#     tags = {
#         Name = "Volume1"
#     }
# }

# resource "aws_network_interface" "EC2NetworkInterface" {
#     description = ""
#     subnet_id = data.aws_subnets.default.ids[0]
#     source_dest_check = true
#     security_groups = [
#         data.aws_security_group.default.id
#     ]
# }

#################################
# Local variables
#################################

variable "availability_zones" {
  default = ["us-east-1d", "us-east-1b", "us-east-1c", "us-east-1a", "us-east-1e", "us-east-1f"]
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

variable "root_volume_size" {
  default = 30
}

variable "root_volume_type" {
  default = "gp3"
}

variable "user_data" {
  default = "IyEvYmluL2Jhc2ggCmVjaG8gRUNTX0NMVVNURVI9Q2x1c3Rlcl9BcGlfMSA+PiAvZXRjL2Vjcy9lY3MuY29uZmlnOw=="
}

variable "iam_instance_profile" {
  default = "LabInstanceProfile"
}

variable "instance_tags" {
  default = {
    Name = "ECS Instance - Cluster_Api_1"
  }
}

variable "autoscaling_group_name" {
  default = "Infra-ECS-Cluster-ClusterApi1-f989b070-ECSAutoScalingGroup-lfz2oHCLhc9t"
}

variable "launch_template_name" {
  default = "ECSLaunchTemplate_T9qfjpHq5vIs"
}

variable "autoscaling_min_size" {
  default = 3
}

variable "autoscaling_max_size" {
  default = 4
}

variable "autoscaling_desired_capacity" {
  default = 3
}

variable "api_container_name" {
  default = "api-candidatos-container"
}

variable "cluster_name" {
  default = "Cluster_Api_1"
}

variable "db_server" {
  default = "DB_API"
}

variable "frontend_container_name" {
  default = "gtio_votacion-frontend"
}

#################################
# Data from AWS
#################################

data "aws_iam_role" "autoscaling_role" {
  name = "AWSServiceRoleForAutoScaling"
}

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

data "aws_iam_instance_profile" "lab_profile" {
  name = "LabInstanceProfile"
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