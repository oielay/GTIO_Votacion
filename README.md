# GTIO_Votacion

## Pasos para desplegar en local

**Pasos previos:**

* Tener instalado Docker
* Clonar el repositorio con `git clone https://github.com/oielay/GTIO_Votacion.git`

**Pasos para el despliegue:**

1. **Configurar variables de entorno:**  
    Situar el archivo `.env` en la raíz del proyecto y configurar las variables de entorno requeridas.

2. **Ejecutar migraciones de Kong (una vez):**  
    Ejecutar el comando `docker-compose up -d kong-migration` una única vez para realizar las migraciones necesarias de Kong.

3. **Construir y levantar los servicios:**  
    Ejecutar el comando `docker-compose up -d --build` para construir las imágenes y levantar los servicios definidos en el archivo `docker-compose.yml`.

4. **Configurar Kong (una vez):**  
    Ejecutar el comando `docker-compose up -d kong-config` una única vez para aplicar la configuración inicial de Kong.

5. **Acceder al servicio deseado:**  
    Una vez que los contenedores estén en ejecución, abrir el navegador en los siguientes puertos en base al servicio que se quiera acceder:
    - `http://localhost:1234` para la aplicación web.
    - `http://localhost:8002` para Kong (se pueden ver servicios, rutas, consumers, plugins...).
    - `http://localhost:9090` para Prometheus (permite ver información sobre métricas).

    Estos servicios se encuentran en la red externa. El resto de servicios no son accesibles desde el navegador dado que se encuentran en la red interna.

6. **Detener los servicios:**
    Para detener los servicios, ejecutar el comando `docker-compose down`.

7. **Volver a levantar los servicios:**
    Una vez creados los volúmenes y hecho las migraciones y configuraciones de kong necesarias, para volver a levantar los servicios, solo es necesario ejecutar el comando `docker-compose up -d`.

**Ejemplo de archivo .env**

DB_NAME_API=[Base_de_datos_candidatos]<br>
DB_NAME_AUTH=[Base_de_datos_autenticacion]<br>
ASPNETCORE_ENVIRONMENT=Development<br>
SQLSERVER_API_PASSWORD=[Contraseña_base_de_datos_candidatos]<br>
SQLSERVER_AUTH_PASSWORD=[Contraseña_base_de_datos_autenticacion]<br>
KONG_DATABASE_PASSWORD=[Contraseña_base_de_datos_kong]<br>
KONG_PG_DATABASE=[Base_de_datos_kong]<br>
KONG_PG_USER=[Usuario_base_de_datos_kong]<br>
KONG_ADMIN_JWT_SECRET=[Secret_token_admin]<br>
