# Servicios de AWS

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 30/04/2025

Historia técnica: [Issue #79](https://github.com/oielay/GTIO_Votacion/issues/79)

## Contexto y Planteamiento del Problema

Para desplegar todos los microservicios que se han desarrollado en local, es necesario definir qué servicios necesitaremos en AWS, que serán necesarios estudiar para replicar la arquitectura que se encuentra en local.

## Servicios y conceptos principales

Para desplegar correctamente nuestra arquitectura de microservicios en AWS, es fundamental comprender el propósito y funcionamiento de los servicios que vamos a utilizar, así como algunos conceptos clave. A continuación, se describe brevemente cada uno:

* **VPC (Virtual Private Cloud):**  
  Es una red virtual privada dentro de AWS que permite definir subredes públicas y privadas. Dentro de esta red se despliegan todos los recursos de nuestra arquitectura, asegurando el aislamiento y el control de tráfico.

* **ECR (Elastic Container Registry):**  
  Servicio de AWS para almacenar, versionar y administrar imágenes Docker en la nube. Desde aquí, otros servicios como ECS pueden extraer las imágenes para desplegar contenedores. El versionado automático permite mantener un historial de imágenes y recuperar versiones anteriores si es necesario.

* **RDS (Relational Database Service):**  
  Servicio administrado de bases de datos relacionales. Facilita la provisión, configuración, escalado y mantenimiento de motores como MySQL, PostgreSQL, SQL Server, entre otros. En nuestro caso usaremos SQL Server.

* **ECS (Elastic Container Service):**  
  Plataforma de orquestación de contenedores que permite ejecutar, escalar y administrar contenedores Docker. Puede utilizar instancias EC2 como infraestructura subyacente, o bien AWS Fargate (para un enfoque sin servidor).

* **Clúster de ECS:**  
  Conjunto de recursos donde se ejecutan las tareas y servicios ECS. Los clústeres permiten organizar entornos (desarrollo, preproducción, producción) y agrupar instancias EC2 o tareas Fargate.

* **Definición de tarea (Task Definition):**  
  Plantilla que describe cómo se debe ejecutar un contenedor: qué imagen usar, qué recursos (CPU/RAM) necesita, qué puertos expone, variables de entorno, volúmenes, etc.

* **Tarea (Task):**  
  Instancia en ejecución de una definición de tarea. Representa un contenedor (o conjunto de contenedores) corriendo activamente con las configuraciones especificadas.

* **EC2 (Elastic Compute Cloud):**  
  Servicio que permite lanzar instancias (máquinas virtuales) en la nube. En el contexto de ECS (con tipo de lanzamiento EC2), los contenedores Docker se ejecutan dentro de estas instancias.

* **Grupo de seguridad (Security Group):**  
  Firewall virtual que controla el tráfico de red entrante y saliente hacia recursos de AWS. Define qué puertos, protocolos e IPs están permitidos, y es esencial para proteger y permitir el acceso a los microservicios.

* **ELB (Elastic Load Balancing):**  
  Servicio que distribuye automáticamente el tráfico entrante entre varias tareas ECS activas. Garantiza alta disponibilidad y balanceo de carga entre las instancias EC2 que ejecutan los contenedores.

* **API Gateway:**  
  Servicio completamente administrado que actúa como puerta de entrada para exponer, proteger, monitorizar y versionar APIs. Permite definir rutas, aplicar autenticación, límites de tráfico, y conectarse con servicios backend como ECS, Lambda o HTTP endpoints.

* **CloudWatch:**
  Es el servicio de observabilidad de AWS, monitorear el rendimiento de los servicios, revisar los logs de los contenedores, crear alarmas cuando se superé cierto umbral de recursos consumidos por parte de los contenedores, detectar errores, entre otros.

## Estructura de los servicios

Para desplegar esta arquitectura de forma coherente, se propone la siguiente estructura:

1. Un repositorio **ECR por microservicio**, donde se almacenarán las imágenes Docker
2. Un único **clúster ECS** que agrupará todos los servicios y tareas desplegadas.
3. Dentro del clúster:
   * Se crearán **servicios ECS** (uno por microservicio).
   * Cada servicio ECS estará asociado a una **definición de tarea específica**.
4. Se utilizarán **instancias EC2** como entorno de ejecución para las tareas. En este caso:
   * Cada una con capacidad para alojar un solo servicio debido a que se ha configurado con **1 vCPU y 1 GB de RAM** por contenedor.
5. Se desplegará un **balanceador de carga (ALB)** para distribuir el tráfico entre las tareas de los servicios ECS.
6. Se creará una **instancia RDS** y dentro se creará una base de datos independiente para cada API.
7. Se configurarán los **grupos de seguridad** para permitir el acceso controlado:
   * Desde el balanceador hacia los servicios ECS.
   * Desde las APIs hacia sus respectivas bases de datos.
8. Se desplegará un **API Gateway** que centralizará el acceso a los microservicios:
   * Definiendo rutas específicas para cada API.
   * Aplicando seguridad y control de tráfico.

## Servicios y recursos empleados en la solución

| Recurso                | Cantidad | Propósito                                                                |
|------------------------|----------|--------------------------------------------------------------------------|
| ECR                    | 3        | Repositorios para imágenes de frontend, API candidatos y autenticación   |
| ECS Cluster            | 1        | Agrupar los servicios ECS y tareas                                       |
| Servicios ECS          | 3        | Gestionar la ejecución y escalado de cada microservicio                  |
| Definiciones de tarea  | 3        | Especificar las características del contendor                            |
| Instancias EC2         | 3        | Ejecutar tareas (una por servicio debido a limitaciones de recursos)     |
| ELB (ALB recomendado)  | 1        | Balancear tráfico entrante hacia las tareas                              |
| RDS                    | 1        | Bases de datos separadas para cada API                                   |
| API Gateway            | 1        | Punto único de entrada y gestión de rutas para las APIs                  |
| Grupos de seguridad    | 1        | Controlar el tráfico entre los componentes                               |

## Enlaces

* [Arquitecturas 1][https://docs.aws.amazon.com/es_es/whitepapers/latest/microservices-on-aws/simple-microservices-architecture-on-aws.html]