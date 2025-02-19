# Elección de la arquitectura del proyecto

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 15/02/2025

Historia técnica: [Issue #1](https://github.com/oielay/GTIO_Votacion/issues/1) [Subissue #20](https://github.com/oielay/GTIO_Votacion/issues/20)


## Contexto y Planteamiento del Problema
Para desarrollar el backend y el frontend, es necesario definir una arquitectura que determinará cómo interactuan las diferentes partes de la aplicación para procesar las solicitudes y las respuesta.

## Factores en la Decisión 

* Facilidad para integrar nuevos servicios
* Escalabilidad
* Flexibilidad

## Opciones Consideradas

* Arquitectura monolítica
* Arquitectura sin servidores
* Arquitectura de microservicios

## Decisión

Se ha decidido emplear como estructura general del sistema, una arquitectura de microservicios que internamente empleará una arquitectura en capas para organizar el código en el caso del Backend y un único front que internamente emplea una arquitectura de componentes.

## Ventajas y Desventajas de las opciones

### Arquitectura monolítica
#### Ventajas

* Facilidad de despliegue ya que no requiere de la orquestación con otros componentes
* Latencia baja debido a que todos los servicios están en un único proyecto

#### Desventajas

* Dificil de mantener conforme va aumentando el código, ya que este se vuelve demasiado complejo
* Para escalar se debe desplegar toda la aplicación interrumpiendo todos los servicios que se ofrecen, aún cuando los cambios sean pequeños.
* Unico punto de fallo. 

### Arquitectura sin servidores

#### Ventajas
* Escalabilidad integrada. La plataforma se encarga de gestionar el escalamiento de la aplicación
* No es necesario administrar la infraestructura.
* Reducción de la complejidad de al eliminar la gestión de los servidores

#### Desventajas
* Coste. Los costes pueden aumentar para aplicaciones que reciben muchas solicitudes
* Limitaciones de control ya que el proveedor gestiona toda la infraestructura


### Arquitectura de microservicios

#### Ventajas

* Libertad tecnológica. Como cada servicio tiene su propio proyecto, la tecnología empleada en su implementación puede ser distinta
* A la hora de escalar, solo se escalan los microservicios que hagan falta.
* Son más fáciles de mantener ya que tienen menos código y este es más específico. Esto se debe a que cada microservicio tiene una única responsabilidad.

#### Desventajas

* Puede llegar a ser muy compleja ya que la aplicación está distribuida en distintos proyectos. Se debe tener en cuenta la comunicación, la latencia, la consistecia en los datos, etc.
* Es más complicado realizar pruebas que involucren a varios servicios
* Consistencia en los datos. Normalmente cada servicio tiene su propia base de datos por lo que pueden surgir inconsistencias

## Enlaces 

* [Arquitecturas 1][https://developers.google.com/solutions/content-driven/backend/architecture?hl=es-419#:~:text=Backend%20architecture%20refers%20to%20how,incoming%20requests%20and%20create%20responses.]
* [Arquitecturas 2][https://learn.microsoft.com/es-es/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures]
* [Ventajas y desventajas monolítica y de microservicios][https://www.ithinkupc.com/es/blog/monolito-o-microservicios-ventajas-y-desventajas]
* [Ventajas y desventajas sin servidor][https://thebridge.tech/blog/serverless-arquitectura-sin-servidor/]



