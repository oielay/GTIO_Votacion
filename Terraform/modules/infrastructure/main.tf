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

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/ecs/api"
  retention_in_days = 30
}

# Load Balancer
resource "aws_lb" "ElasticLoadBalancingV2LoadBalancer" {
  name               = "balanceador-candidatos"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups = [
    aws_security_group.sg_frontend.id,
    aws_security_group.sg_backend.id
  ]
  ip_address_type = "ipv4"
  access_logs {
    enabled = false
    bucket  = ""
    prefix  = ""
  }
  idle_timeout                     = "60"
  enable_deletion_protection       = "false"
  enable_http2                     = "true"
  enable_cross_zone_load_balancing = "true"

  tags = {
    Name = "balanceador-candidatos"
  }
}

# Listener Api
resource "aws_lb_listener" "ElasticLoadBalancingV2Listener" {
  load_balancer_arn = aws_lb.ElasticLoadBalancingV2LoadBalancer.arn
  port              = 8080
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup.arn
    type             = "forward"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "AutoScalingAutoScalingGroup" {
  name = var.autoscaling_group_name
  launch_template {
    id      = aws_launch_template.EC2LaunchTemplate.id
    version = "1"
  }
  min_size                  = var.desired_count
  max_size                  = var.desired_count * 4
  desired_capacity          = var.desired_count * 2
  default_cooldown          = 300
  health_check_type         = "EC2"
  health_check_grace_period = 0
  vpc_zone_identifier       = data.aws_subnets.default.ids
  termination_policies = [
    "Default"
  ]
  service_linked_role_arn = data.aws_iam_role.autoscaling_role.arn
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "ECS Instance - Cluster_Api_1"
    propagate_at_launch = true
  }
}

# Launch Template
resource "aws_launch_template" "EC2LaunchTemplate" {
  name      = var.launch_template_name
  user_data = var.user_data
  iam_instance_profile {
    arn = data.aws_iam_instance_profile.lab_profile.arn
  }
  key_name = var.key_name
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    security_groups = [
      data.aws_security_group.default.id
    ]
  }
  image_id      = var.ami_id
  instance_type = var.instance_type
}

# Target Group
resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
  health_check {
    interval            = 30
    path                = "/api/Candidates/Test"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200"
  }
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
  name        = "grupo-apiCandidatos"
}

#################################
# Servicio: Frontend
#################################

# Log group
resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/ecs/frontend"
  retention_in_days = 7
}

# Listener Frontend
resource "aws_lb_listener" "load_balancer_listener_frontend" {
  load_balancer_arn = aws_lb.ElasticLoadBalancingV2LoadBalancer.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.load_balancer_target_group_frontend.arn
    type             = "forward"
  }
  depends_on = [aws_lb_target_group.load_balancer_target_group_frontend]
}

# Target Group Frontend
resource "aws_lb_target_group" "load_balancer_target_group_frontend" {
  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200-299"
  }
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
  name        = "grupo-front"
}

#################################
# Base de Datos: RDS SQL Server
#################################

# RDS
resource "aws_db_instance" "RDSDBInstance" {
  identifier                          = "sqlserver"
  allocated_storage                   = 20
  instance_class                      = "db.t3.micro"
  engine                              = "sqlserver-ex"
  username                            = "sa"
  password                            = var.sql_password
  backup_window                       = "07:41-08:11"
  backup_retention_period             = 1
  availability_zone                   = data.aws_availability_zones.available.names[0]
  maintenance_window                  = "sat:04:41-sat:05:11"
  multi_az                            = false
  engine_version                      = "15.00.4430.1.v1"
  auto_minor_version_upgrade          = false
  license_model                       = "license-included"
  character_set_name                  = "SQL_Latin1_General_CP1_CI_AS"
  publicly_accessible                 = true
  storage_type                        = "gp2"
  port                                = 1433
  storage_encrypted                   = true
  kms_key_id                          = var.kms_key_id
  copy_tags_to_snapshot               = true
  monitoring_interval                 = 0
  iam_database_authentication_enabled = false
  deletion_protection                 = false
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_gtio_votacion.name
  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.sg_db.id
  ]
  skip_final_snapshot = true

  tags = {
    Name = var.db_server
  }
}

resource "aws_db_subnet_group" "db_subnet_gtio_votacion" {
  name        = "db-subnet-gtio-votacion"
  description = "DB subnet group"
  subnet_ids  = data.aws_subnets.default.ids

  tags = {
    Name = "db-subnet-gtio-votacion"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sql-access"
  description = "Allow SQL Server access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "RDS SQL Server"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Api candidatos"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS SQL Security Group"
  }
}

resource "aws_security_group" "sg_frontend" {
  name        = "gtio-sg-frontend"
  description = "Allow HTTP/HTTPS traffic from the internet"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Frontend (3000)"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Frontend Security Group"
  }
}

resource "aws_security_group" "sg_backend" {
  name        = "gtio-sg-backend"
  description = "Allow traffic from frontend to API"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "API candidatos (8080)"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # security_groups  = [data.aws_security_group.default.id, aws_security_group.sg_frontend.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Backend Security Group"
  }
}

resource "aws_security_group" "sg_db" {
  name        = "gtio-sg-db"
  description = "Allow SQL Server access from backend only"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SQL Server"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    # security_groups  = [data.aws_security_group.default.id, aws_security_group.sg_backend.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security Group"
  }
}

#################################
# Api Gateway AWS
#################################

# Api Gateway REST API
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "gtio-votacion-api-gateway"
  description = "API para el servicio de votación"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowAllInvoke",
        Effect    = "Allow",
        Principal = "*",
        Action    = "execute-api:Invoke",
        Resource  = "arn:aws:execute-api:*:*:*/*"
      }
    ]
  })

  tags = {
    Name = "gtio-votacion-api-gateway"
  }
}

# Resource: /api
resource "aws_api_gateway_resource" "api_base" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "api"
}

# Resource: /api/test
resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_base.id
  path_part   = "test"
}

# Method: ANY on /api/test
resource "aws_api_gateway_method" "test_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integration: Forward to ALB
resource "aws_api_gateway_integration" "test_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.test_resource.id
  http_method             = aws_api_gateway_method.test_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}:8080/api/Candidates/Test"
}

# Method: ANY on /frontend
resource "aws_api_gateway_method" "frontend_method" {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = false
}

# Integration: Forward to ALB
resource "aws_api_gateway_integration" "frontend_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method             = aws_api_gateway_method.frontend_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}:3000"
}

# resource "aws_lb_listener_rule" "require_header" {
#   listener_arn = aws_lb_listener.ElasticLoadBalancingV2Listener.arn
#   priority     = 10

#   condition {
#     http_header {
#       http_header_name = "x-amzn-apigateway-api-id"
#       values           = ["*"] # acepta cualquier valor siempre que el header esté presente
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup.arn
#   }
# }

# # Regla para bloquear si NO tienen el header 'prueba'
# resource "aws_lb_listener_rule" "block_if_missing_header" {
#   listener_arn = aws_lb_listener.ElasticLoadBalancingV2Listener.arn
#   priority     = 20

#   condition {
#     # Ningún valor significa que no cumple con la anterior
#     # y cae en esta si no tenía el header
#     # (esto funciona como fallback en ausencia del anterior)
#     # No conditions = catch-all
#     # But to simulate missing header:
#     # use not having the above condition
#   }

#   action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Request blocked"
#       status_code  = "403"
#     }
#   }
# }

# Resource: /api/obtenerTodosCandidatos
resource "aws_api_gateway_resource" "obtener_todos_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_base.id
  path_part   = "obtenerTodosCandidatos"
}

# Method: ANY on /api/obtenerTodosCandidatos
resource "aws_api_gateway_method" "obtener_todos_method" {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.obtener_todos_resource.id
  api_key_required = true
  http_method      = "ANY"
  authorization    = "NONE"
}

# Integration: Forward to ALB
resource "aws_api_gateway_integration" "obtener_todos_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.obtener_todos_resource.id
  http_method             = aws_api_gateway_method.obtener_todos_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}:8080/api/Candidates/ObtenerTodosCandidatos"
}

# Configuración del stage "prod" con CloudWatch Logs
resource "aws_api_gateway_deployment" "prod_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  depends_on = [
    aws_api_gateway_method.test_method,
    aws_api_gateway_method.obtener_todos_method,
    aws_api_gateway_resource.obtener_por_id_base,
    aws_api_gateway_resource.obtener_por_id_param,
    aws_api_gateway_integration.test_integration,
    aws_api_gateway_integration.obtener_todos_integration,
    aws_api_gateway_integration.obtener_por_id_integration
  ]
}

# Configuración de CloudWatch Logs para la API Gateway
resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name = "/aws/api-gateway/gtio-votacion-api-gateway"
}

resource "aws_api_gateway_stage" "prod_stage" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "prod"
  deployment_id = aws_api_gateway_deployment.prod_deployment.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  tags = {
    Name = "gtio-votacion-prod-stage"
  }

  depends_on = [
    aws_api_gateway_account.account_settings
  ]
}

# Listener en ALB que redirige tráfico a la API Gateway
resource "aws_lb_listener" "http_listener_for_gateway" {
  load_balancer_arn = aws_lb.ElasticLoadBalancingV2LoadBalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup.arn
  }
}

# Resource: /api/obtenerCandidatoPorId/{id}
resource "aws_api_gateway_resource" "obtener_por_id_base" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_base.id
  path_part   = "obtenerCandidatoPorId"
}

resource "aws_api_gateway_resource" "obtener_por_id_param" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.obtener_por_id_base.id
  path_part   = "{id}"
}

# Method: ANY on /api/obtenerCandidatoPorId
resource "aws_api_gateway_method" "obtener_por_id_method" {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.obtener_por_id_param.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.id" = true
  }
}

# Integration: Forward to ALB
resource "aws_api_gateway_integration" "obtener_por_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.obtener_por_id_param.id
  http_method             = aws_api_gateway_method.obtener_por_id_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}:8080/api/Candidates/ObtenerCandidatoPorId/{id}"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

# Api key
resource "aws_api_gateway_api_key" "cliente_api_key" {
  name        = "key"
  description = "API Key"
  enabled     = true
  value       = var.api_key
}

# Usage plan
resource "aws_api_gateway_usage_plan" "cliente_usage_plan" {
  name = "usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.rest_api.id
    stage  = aws_api_gateway_stage.prod_stage.stage_name
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }

  quota_settings {
    limit  = 1000
    period = "MONTH"
  }
}

# Usage plan key
resource "aws_api_gateway_usage_plan_key" "cliente_key_link" {
  key_id        = aws_api_gateway_api_key.cliente_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.cliente_usage_plan.id
}

# Cloudwatch role for API Gateway
resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = data.aws_iam_role.lab_role.arn
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

data "aws_availability_zones" "available" {
  state = "available"
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

variable "api_key" {
  description = "API Key"
  type        = string
}

variable "desired_count" {
  description = "Cantidad deseada de instancias"
  type        = number
}

#################################
# Output variables
#################################

output "lb_dns_name" {
  value = aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "api_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "frontend_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "target_group_api_arn" {
  value = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup.arn
}

output "target_group_frontend_arn" {
  value = aws_lb_target_group.load_balancer_target_group_frontend.arn
}

output "listener_api_arn" {
  value = aws_lb_listener.ElasticLoadBalancingV2Listener.arn
}

output "listener_frontend_arn" {
  value = aws_lb_listener.load_balancer_listener_frontend.arn
}
