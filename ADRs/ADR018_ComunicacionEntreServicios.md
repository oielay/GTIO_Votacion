# Comunicación entre servicios: arquitectura basada en contenedores

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 26/02/2025

Historia técnica: [Issue #55](https://github.com/oielay/GTIO_Votacion/issues/55)

## Contexto y Planteamiento del Problema

Es crucial definir cómo se van a comunicar los servicios entre sí desde el principio, ya que esto influye en la arquitectura y el rendimiento del sistema. Elegir un sistema de comunicación adecuado facilita el desarrollo, mejora la interoperabilidad y optimiza el intercambio de datos, reduciendo la complejidad y los posibles problemas a largo plazo.

## Factores en la Decisión 

* Facilidad de implementación
* Escalabilidad y flexibilidad
* Resiliencia
* Seguridad frente al exterior

## Opciones Consideradas

* Redes Docker
* Docker Compose
* Exponer puertos y utilizar HTTP/REST o gRPC

## Decisión

Hemos elegido la opción de **Docker Compose** porque nos parece la forma más sencilla y eficiente para gestionar las comunicaciones entre contenedores. Esta herramienta permite definir todos los servicios y sus configuraciones en un solo archivo `docker-compose.yml`, facilitando la creación y gestión de contenedores sin tener que configurar manualmente redes y enlaces entre ellos. Además, Docker Compose maneja automáticamente la comunicación entre contenedores a través de redes internas y simplifica la orquestación de servicios, lo que agiliza tanto el desarrollo como el mantenimiento de aplicaciones complejas.

## Explicación a detalle de las comunicaciones entre contenedores

Para gestionar las peticiones de front correctamente, hemos hecho que el contenedor de frontend actúe como proxy (configuración en el archivo astro.config.mjs) hacia el microservicio de candidatos. De esta forma, las peticiones y respuestas llegan correctamente a sus destinos y la comunicación es la correcta. Por otro lado, los usuarios que quieran pueden hacer llamadas a los dos microservicios (candidatos y autenticación) mediante la Api Gateway de Kong. Se han puesto los microservicios en una red interna para que no se puedan realizar peticiones a los mismos directamente.

Esto obliga a que las peticiones tengan que pasar obligatoriamente por Kong, donde hemos implementado un sistema de autenticación con tokens Jwt (microservicio de autenticación para registrarse y obtener tokens) y autorización con el plugin ACL (solamente el admin puede modificar los datos de la api de candidatos, los demás usuarios pueden realizar peticiones de lectura). Por último, tenemos el plugin de File-log para el tema de logging y Prometheus para medir las métricas más a fondo.

## Ventajas y Desventajas de las opciones

### Redes Docker

[Más información](https://indumathimanivannan.medium.com/docker-network-modes-explained-bridge-host-and-overlay-comparisons-d691857f9d30)

#### Ventajas

* Comunicaciones internas simplificadas
* Aislamiento de contenedores
* Facilidad de configuración
* Escalabilidad y flexibilidad
* Compatibilidad con múltiples redes

#### Desventajas

* Complejidad en la configuración avanzada
* Dependencia de la infraestructura de red
* Potencial sobrecarga de red
* Limitaciones en redes de contenedores distribuidos

### Docker Compose

[Más información](https://docs.docker.com/compose/how-tos/networking/)

#### Ventajas

* Facilidad en la creación de redes entre contenedores
* Aislamiento de redes
* Redes predeterminadas
* Flexibilidad en la configuración
* Simplicidad en la gestión

#### Desventajas

* Limitación a entornos de desarrollo
* Falta de orquestación avanzada
* Escalabilidad limitada
* Redes no persistentes

### Exponer puertos y utilizar HTTP/REST o gRPC

[Más información](https://docs.docker.com/get-started/docker-concepts/running-containers/publishing-ports/)

#### Ventajas de exponer puertos y utilizar HTTP/REST o gRPC

* Comunicación sencilla entre contenedores y servicios externos
* Amplio soporte de herramientas y bibliotecas
* Fácil integración con aplicaciones externas
* Escalabilidad horizontal eficiente
* Flexibilidad en la elección de protocolos (REST o gRPC)

#### Desventajas de exponer puertos y utilizar HTTP/REST o gRPC

* Riesgos de seguridad si no se configuran adecuadamente
* Sobrecarga en la red para comunicaciones complejas
* Puede requerir configuraciones adicionales de balanceo de carga
* Latencia añadida en comparación con las comunicaciones dentro de la misma red Docker