# GTIO_Votacion

## Documentación

La documentación del proyeto se puede encontrar en el apartado [Wiki](https://github.com/oielay/GTIO_Votacion/wiki) del repositorio.

## Pasos para desplegar en local

**Pasos previos:**

- Tener instalado Docker
- Tener instalado Terraform
- Tener instalado AWS CLI
- Tener cuenta de AWS
- Tener creado un bucket S3 para almacenar el estado de Terraform
- Clonar el repositorio con `git clone https://github.com/oielay/GTIO_Votacion.git`

**Pasos para el despliegue:**

1. **Configurar variables de entorno y de terraform:**

   - Situar el archivo `.env` en la raíz del proyecto y configurar las variables de entorno requeridas. (ejemplo al final del README)
   - Situar el archivo `env.tfvars` en la carpeta `Terraform` y configurar las variables de terraform requeridas. (ejemplo al final del README)

2. **Configurar credenciales de AWS:**  
   Copiar las credenciales de AWS en el archivo `~/.aws/credentials`. (ejemplo al final del README)

3. **Crear repositorio ECR con Terraform:**  
   Ejecutar los siguientes comandos para crear el repositorio ECR:

   ```bash
   cd Terraform
   terraform init
   terraform fmt
   terraform validate
   terraform apply -auto-approve -target=module.ecr -var-file=env.tfvars
   ```

4. **Construir y subir imágenes de la API:**  
   Construir las imágenes Docker y subirlas al repositorio ECR:

   ```bash
   docker-compose build api
   docker tag gtio_votacion-api <Repositorio de ECR>/gtio_votacion/api:<Tag de la imagen>
   docker push <Repositorio de ECR>/gtio_votacion/api:<Tag de la imagen>
   ```

5. **Crear infraestructura y desplegar la API con Terraform:**  
   Ejecutar los siguientes comandos para desplegar la infraestructura y la API:

   ```bash
   terraform apply -auto-approve -var-file=env.tfvars -target=module.infrastructure -target=module.api
   ```

6. **Poblar la base de datos:**  
   Ejecutar el script de poblamiento de la base de datos:

   ```bash
   curl -X POST http://<URL del balanceador de datos>:8080/api/Candidates/CrearBaseDeDatos
   ```

7. **Construir y subir imágenes del frontend:**  
   Construir las imágenes Docker y subirlas al repositorio ECR:

   ```bash
   docker-compose build frontend
   docker tag gtio_votacion-frontend <Repositorio de ECR>/gtio_votacion/frontend:<Tag de la imagen>
   docker push <Repositorio de ECR>/gtio_votacion/frontend:<Tag de la imagen>
   ```

8. **Crear servicio del frontend con Terraform:**  
   Ejecutar los siguientes comandos para desplegar el servicio del frontend:
   ```bash
   terraform apply -auto-approve -var-file=env.tfvars -target=module.frontend
   ```

**Ejemplo de archivo .env**

```ini
DB_NAME_API=<Base_de_datos_candidatos>
ASPNETCORE_ENVIRONMENT=<Development>
SQLSERVER_API_PASSWORD=<Contraseña_base_de_datos_candidatos>
PUBLIC_API_URL=<http://<DNS del balanceador de carga>:8080>
```

**Ejemplo de archivo env.tfvars**

```ini
kms_key_id = "<ARN de la clave KMS>"
task_api_secret = "<ARN del secreto>:ConnectionStrings__DefaultConnection::"
task_api_secret_master = "<ARN del secreto>:ConnectionStrings__MasterConnection::"
api_image = "<Repositorio de ECR>/gtio_votacion/api:latest"
sql_password = "<Contraseña_base_de_datos_candidatos>"
frontend_image = "<Repositorio de ECR>/gtio_votacion/frontend:latest"
```

**Ejemplo de archivo credentials**

```ini
[default]
aws_access_key_id=<Tu_aws_access_key_id>
aws_secret_access_key=<Tu_aws_secret_access_key>
aws_session_token=<Tu_aws_session_token>
```
