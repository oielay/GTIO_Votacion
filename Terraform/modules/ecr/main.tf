#################################
# ECR: repositorios de imagenes
#################################

resource "aws_ecr_repository" "api_repo" {
    name = "gtio_votacion/api"

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_ecr_repository" "frontend_repo" {
    name = "gtio_votacion/frontend"

    lifecycle {
        prevent_destroy = true
    }
}