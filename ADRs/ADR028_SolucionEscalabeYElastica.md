# Uso de Servicios AWS para una Arquitectura Escalable y Elástica

* Estado: aceptada  
* Responsables: Urki Aristu, Oier Layana, Javier Pernaut, Oier Alduncin y Alexander Sarango  
* Fecha: 05/05/2025  

Historia técnica: [Issue #81](https://github.com/oielay/GTIO_Votacion/issues/81)

## Contexto y Planteamiento del Problema

En el desarrollo y despliegue de aplicaciones modernas, surge la necesidad de contar con una arquitectura que permita escalar eficientemente en función de la demanda, al tiempo que se garantiza la disponibilidad, la automatización del despliegue y el mantenimiento operativo. Por ello, se ha planteado utilizar una solución basada en servicios gestionados de AWS junto con Terraform para definir la infraestructura como código.

## Decisión Arquitectónica

Se ha decidido utilizar los siguientes componentes en la arquitectura:

- **ECS (Elastic Container Service)**: Para orquestar contenedores Docker, facilitando la ejecución y escalado de microservicios.
- **ECR (Elastic Container Registry)**: Como repositorio seguro y gestionado para almacenar las imágenes de contenedor.
- **S3 (Simple Storage Service)**: Para el almacenamiento escalable de archivos estáticos, datos y logs.
- **Terraform**: Para definir y desplegar la infraestructura de manera reproducible y controlada mediante código.

## Justificación

Esta decisión proporciona **escalabilidad** y **elasticidad** a la arquitectura por las siguientes razones:

- **Escalabilidad horizontal**: ECS permite escalar servicios automáticamente en función del uso de CPU o memoria, lo cual es ideal para aplicaciones que experimentan cargas variables.
- **Elasticidad en tiempo real**: La infraestructura se adapta dinámicamente al tráfico de usuarios, levantando o deteniendo contenedores de manera automática sin intervención manual.
- **Desacoplamiento mediante almacenamiento en S3**: Permite gestionar grandes volúmenes de datos de forma independiente y escalable, sin afectar al rendimiento del backend. En nuestro caso lo utilizamos simplemente como almacenaje para ficheros importantes como el `.env`.
- **Automatización y consistencia con Terraform**: La definición de la infraestructura como código asegura despliegues controlados, repetibles y auditables. Facilita el mantenimiento de entornos consistentes entre desarrollo, pruebas y producción.
- **Entregas rápidas con ECR y CI/CD**: ECR permite almacenar y acceder rápidamente a las imágenes de contenedor, facilitando integraciones continuas mediante pipelines.

## Consideraciones Adicionales

- Se integrará esta arquitectura con un pipeline de CI/CD para que las imágenes se construyan y desplieguen automáticamente al realizar cambios en la rama `main` y `desarrollo` que son las principales ramas de trabajo.
- Se controlará el versionado de infraestructura con Git, usando buenas prácticas en ramas como en el resto del proyecto.

## Alternativas Consideradas

- **Despliegue en servidores EC2 manuales**: Requiere mayor mantenimiento y no ofrece elasticidad automática.
- **Soluciones serverless como Lambda**: No se adaptan bien al modelo de ejecución continua de contenedores y microservicios con estados prolongados.

## Consecuencias

- Permite una arquitectura robusta, autosuficiente y preparada para escalar automáticamente sin intervención humana.
- Mejora el tiempo de respuesta y disponibilidad en producción.
- Aumenta la complejidad inicial del setup, pero reduce significativamente la carga operativa a largo plazo.
