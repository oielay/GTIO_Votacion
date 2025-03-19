# ¿Por qué la solución es escalable y elástica?

- Estado: aceptada
- Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana
- Fecha: 26/02/2025

Historia técnica: [Issue #61](https://github.com/oielay/GTIO_Votacion/issues/61)

## Contexto

El proyecto de votación de candidatos va evolucionando y se vuelve más complejo con el tiempo. Actualmente, el proyecto se compone de una aplicación web, una API de candidatos, una base de datos SQL Server, un servidor de métricas Prometheus y un gateway API Kong. Además, se han añadido pruebas de integración y se ha configurado un proceso de CI/CD con GitHub Actions. Para facilitar el desarrollo y las pruebas, es necesario contar con un entorno de test local que sea escalable y elástico, es decir, que pueda adaptarse a los cambios en el proyecto y soportar un mayor número de servicios y usuarios.

## Factores para la respuesta

- **Escalabilidad:** El entorno de test local debe ser capaz de crecer y adaptarse a los cambios en el proyecto, soportando nuevos servicios y configuraciones.
- **Elasticidad:** El entorno de test local debe ser flexible y capaz de ajustarse a la demanda, escalando los recursos según sea necesario.

## Respuesta

La solución propuesta es escalable y elástica principalmente gracias a su arquitectura en capas y el uso de tecnologías como contenedores. Esta estructura permite que cada componente del sistema funcione de manera independiente, facilitando su mantenimiento, actualización y escalado según las necesidades.

1. **Arquitectura basada en capas:**  
    El sistema está dividido en capas, como la capa de frontend (aplicación web), la capa de lógica de negocio (APIs) y la capa de datos (base de datos SQL Server). Esta separación de responsabilidades permite que cada capa pueda escalarse de forma independiente. Por ejemplo, si la base de datos necesita manejar más carga, se pueden añadir más instancias o réplicas sin afectar al resto del sistema.

2. **Servicios independientes y desacoplados:**  
    Cada funcionalidad del sistema se implementa como un servicio independiente. Esto permite que los servicios puedan escalarse horizontalmente (añadiendo más instancias) o verticalmente (aumentando los recursos de una instancia) según la demanda específica de cada uno, optimizando el uso de recursos.

3. **Uso de contenedores para despliegue:**  
    La utilización de contenedores, como Docker, asegura que los servicios sean portables y fáciles de desplegar en diferentes entornos. Cada contenedor incluye un servicio junto con sus dependencias, garantizando consistencia en su ejecución. Además, herramientas como Docker Compose permiten gestionar el escalado y la elasticidad de los servicios.

4. **Integración continua y pruebas automatizadas:**  
    La configuración de un pipeline de CI/CD con GitHub Actions permite integrar y desplegar cambios de manera continua y controlada. Esto asegura que el entorno de pruebas local pueda adaptarse rápidamente a los cambios en el proyecto, manteniendo su capacidad de escalar y ajustarse a nuevas demandas.

En conclusión, la combinación de una arquitectura por capas, servicios desacoplados y el uso de contenedores proporciona una solución robusta y flexible. Esto asegura que el entorno de pruebas local pueda adaptarse a las necesidades del proyecto y soportar un mayor número de servicios y usuarios de manera eficiente.
