# Arquitectura de la solución: arquitectura basada en contenedores

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 26/02/2025

Historia técnica: [Issue #54](https://github.com/oielay/GTIO_Votacion/issues/54)

## Contexto y Planteamiento del Problema

Es fundamental establecer la arquitectura interna que tendrá la solución, ya que esto servirá como base para el desarrollo del sistema y garantizará una estructura organizada y sostenible a lo largo del tiempo. Una arquitectura bien definida no solo proporcionará claridad en la dirección del proyecto, sino que también permitirá una mejor distribución de responsabilidades dentro del código, facilitando la incorporación de nuevas funcionalidades y la escalabilidad de la aplicación. Además, ayudará a reducir la complejidad en el mantenimiento futuro, optimizando el trabajo en equipo y asegurando una evolución del sistema de manera eficiente y ordenada.

## Factores en la Decisión 

* Facilidad de implementación
* Escalabilidad y flexibilidad
* Resiliencia

## Opciones Consideradas

* Arquitectura basada en contenedores
* Arquitectura basada en eventos
* Arquitectura serverless
* Arquitectura SPA (Single Page APP) con microservicios

## Decisión

Nos hemos decantado por la arquitectura basada en contenedores ya que, aunque al principio sea complicada de gestionar, es la más flexible y escalable. Además, permite añadir nuevas utilidades y microservicios de forma muy fácil una vez el sistema está en marcha. Asimismo, es sencillo mover todo el proyecto a diferentes entornos de ejecución (por la naturaleza encapsulada de los contenedores) y es fácil añadir nuevos cambios al entorno de producción sin necesidad de detener el servicio por un tiempo largo.

## Explicación a detalle de la arquitectura

Hemos elegido usar contenedores Docker para la arquitectura del proyecto. Tenemos varios contenedores en este momento, y seguramente aumenten en cantidad en el futuro. Primeramente, tenemos un frontend en un contenedor Docker. Aparte tenemos un Kong Api Gateway para gestionar las llamadas al backend, a los diferentes servicios. En el backend de momento tenemos dos servicios en contenedores, uno para los datos de los candidatos y otro para autenticarse (ambos también en contenedores). Cada microservicio también tiene su propia base de datos para cumplir con la independencia.

El frontend se conecta directamente con el microservicio de candidatos, sin pasar por Kong. Si un usuario quiere usar los servicios de la API de candidatos tiene que usar la Api Gateway de Kong. Para ello se ha implementado un sistema de autenticación basado en tokens Jwt, el cual se gestiona entre Kong y el microservicio de autenticación. Por último, como tenemos Kong con base de datos, existe otro contenedor para albergar el PostgreSQL necesario. Los usuarios normales solo podrán acceder a peticiones de lectura, no de escritura o borrado. Tampoco se podrá acceder directamente al microservicio de candidatos.

## Ventajas y Desventajas de las opciones

### Arquitectura basada en contenedores

[Más información](https://learn.microsoft.com/es-es/dotnet/architecture/microservices/architect-microservice-container-applications/)

#### Ventajas

* Portabilidad entre entornos
* Escalabilidad automática
* Aislamiento y mayor seguridad
* Facilita despliegues continuos
* Alta eficiencia en el uso de recursos
* Manejo simplificado de dependencias

#### Desventajas

* Complejidad en la gestión y orquestación
* Dificultad en monitorización y depuración
* Manejo complicado de datos persistentes
* Sobrecarga en la gestión de infraestructura

### Arquitectura basada en eventos

[Más información](https://www.ibm.com/mx-es/topics/event-driven-architecture)

#### Ventajas

* Alta escalabilidad y flexibilidad
* Desacoplamiento entre componentes
* Facilita la integración de nuevos servicios
* Mejor soporte para sistemas distribuidos
* Permite el procesamiento en tiempo real

#### Desventajas

* Complejidad en la implementación y gestión
* Difícil de depurar debido a la naturaleza asíncrona
* Requiere herramientas especializadas como brokers de eventos
* Gestión compleja de la consistencia de datos

### Arquitectura serverless

[Más información](https://aws.amazon.com/es/what-is/serverless-computing/)

#### Ventajas

* Escalabilidad automática sin gestión de servidores
* Costos reducidos al pagar solo por uso
* Despreocupación por la infraestructura y mantenimiento
* Rápido desarrollo y despliegue de funciones
* Ideal para tareas event-driven y aplicaciones pequeñas

#### Desventajas

* Limitaciones en el tiempo de ejecución y almacenamiento
* Complejidad en la integración entre funciones
* Dificultad para depurar aplicaciones distribuidas
* Riesgo de bloqueo de proveedor (vendor lock-in)

### Arquitectura SPA (Single Page APP) con microservicios

[Más información](https://juanda.gitbooks.io/webapps/content/spa/arquitectura_de_un_spa.html)

#### Ventajas

* Mejora la experiencia del usuario con interfaces interactivas y rápidas
* Desacopla el frontend del backend, permitiendo desarrollo independiente
* Ideal para aplicaciones web dinámicas y en tiempo real
* Escalabilidad y flexibilidad en ambos lados (frontend y backend)
* Permite el uso de microservicios para una gestión eficiente de funcionalidades

#### Desventajas

* Complejidad en la integración entre el frontend y los microservicios
* Requiere una arquitectura de API robusta y bien definida
* Puede ser difícil de mantener a medida que la aplicación crece
* La gestión del estado en el frontend puede volverse compleja