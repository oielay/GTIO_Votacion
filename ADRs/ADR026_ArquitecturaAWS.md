# Arquitectura en aws de la solución

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 30/04/2025

Historia técnica: [Issue #77](https://github.com/oielay/GTIO_Votacion/issues/77) [Subissue #78](https://github.com/oielay/GTIO_Votacion/issues/79)


## Contexto y Planteamiento del Problema

Al diseñar la arquitectura en AWS, es necesario definir qué componentes de los servicios actuales se mantendrán y cuáles serán reemplazados o eliminados. Esta evaluación puede influir en la forma final que adoptará la arquitectura.

## Factores de decisión

- Facilidad de uso  
- Integración con el ecosistema de AWS

## Opciones consideradas

Se ha decidido mantener la arquitectura basada en microservicios en AWS, con ciertas actualizaciones:

- Uso de Docker con **Kong** o reemplazo por **API Gateway de AWS**  
- Elección entre **Grafana** o **CloudWatch** como plataforma de observabilidad  
- Persistencia de datos mediante **contenedor de SQL Server** o **Amazon RDS**

## Decisión

Optamos por una arquitectura de microservicios en la que se reemplazará **Kong** por **API Gateway de AWS**, debido a que este servicio es nativo del ecosistema de Amazon, se escala automáticamente según la demanda y no requiere desplegar imágenes Docker.

En cuanto a observabilidad, se ha elegido **Grafana** por su capacidad de integrarse con CloudWatch, su interfaz más amigable y personalizable, y sus menores costos en ciertas configuraciones, aunque requiere gestión propia de infraestructura.

Finalmente, se sustituye el contenedor de **SQL Server** por el servicio **Amazon RDS**. Esta decisión se basa en su integración nativa con AWS, facilidad de configuración y capacidad para escalar y administrar bases de datos de forma sencilla.

## Explicación de la Infraestructura

La arquitectura anterior estaba compuesta por contenedores locales que ejecutaban los microservicios de la API de candidatos y la API de autenticación/autorización. Además, se utilizaba un contenedor de SQL Server, **Kong** para la gestión de accesos externos, y un frontend para el sistema de votación.

En la nueva arquitectura, se mantienen cuatro servicios principales (frontend, API de candidatos, API de autenticación/autorización y Grafana), todos desplegados en contenedores Docker dentro del entorno de AWS, donde estarán asociados a tareas en servicios como ECS.

El contenedor de SQL Server será eliminado y sustituido por **una instancias de RDS**, lo que permitirá una gestión más eficiente y escalable de las bases de datos SQL Server.

## Ventajas y Desventajas de las Opciones

### Emplear RDS en lugar de contenedores con SQL Server

#### Ventajas

- Integración nativa con el ecosistema AWS  
- Configuración sencilla  
- Copias de seguridad automatizadas  
- Alta disponibilidad mediante replicación

#### Desventajas

- Limitaciones en configuraciones avanzadas  
- Costos superiores en comparación con contenedores autogestionados  
- Menor portabilidad entre entornos  
- No está optimizado para escalabilidad horizontal

### Emplear API Gateway de AWS en lugar de Kong

#### Ventajas

- Integración total con AWS  
- Escalabilidad automática según la carga de solicitudes  
- Soporte nativo para JWT sin necesidad de plugins adicionales

#### Desventajas

- Costos más altos que una solución autogestionada con Kong  
- Menor capacidad de personalización avanzada  
- Limitaciones como número máximo de rutas por API

### Emplear Grafana en lugar de CloudWatch

#### Ventajas

- Compatibilidad con múltiples fuentes de datos  
- Portabilidad: se puede desplegar fuera de AWS  
- Dashboards altamente personalizables

#### Desventajas

- Grafana solo visualiza datos; necesita herramientas como CloudWatch o Prometheus para recolectarlos  
- Dependencia de terceros para logs y trazas (como **Loki**)  
- Integración menos directa con servicios nativos de AWS, como Lambda o CloudTrail

## Enlaces 

* [Arquitecturas 1][https://docs.aws.amazon.com/es_es/whitepapers/latest/microservices-on-aws/simple-microservices-architecture-on-aws.html]



