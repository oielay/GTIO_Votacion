# [Autenticación, autorización y auditoria]

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 26/02/2025

Historia técnica: [Issue #60](https://github.com/oielay/GTIO_Votacion/issues/60)


## Contexto y Planteamiento del Problema
Se debe especificar cómo se va a realizar la autenticación, autorización y auditoria del sistema. De esta forma, mediante la autenticación vamos a poder verificar la identidad de un usuario y así devolver un token con permisos de administrador que le permitirá realizar llamadas a los endpoints de la API. Por otro lado, para realizar la auditoria, desde kong se realiza un registro de los accesos a los endpoints de los microservicios, permitiendo rastrear las llamadas.

## Factores en la Decisión 

* Complejidad de las tecnologías
* Tecnologías de obligado uso

## Opciones Consideradas

* Kong (APi Gateway, autorización básica y auditoría)
* JWT (autenticación y autorización)
* OAuth (autenticación y autorización)

## Decisión

* No se han tenido en cuenta otras tecnologias de api gateway ya que era un requisito emplear kong para realizar esa labor.
* Se ha elegido JWT para la autenticación y autorización debido a su sencillez, felxibilidad y seguridad.

## Ventajas y Desventajas de las opciones

### JWT para autenticación y autorización
#### Ventajas

* Los tokens JWT son ligeros, por lo que se puede implementar en entornos HTML y HTTP, lo que los hace ideales para aplicaciones cliente
* Los JWT vienen con un mecanismo de caducidad incorporado, lo que permite establecer un periodo de caducidad para mejorar la seguridad
* Sencillos de usar
* Ahorran espacio en las bases de datos

#### Desventajas

* El desarrollador es el responsable de garantizar la seguridad de la clave de cifrado.
* Cuando caduca un token, el usuario tiene que volver a autenticarse para obtener un nuevo token. La experiencia de usuario empeora
* Dificil de implementar en la solución. Se tiene que configurar el proceso de creación de tokens, elegir el mecanismo de firmado adecuado e integrarlo en la arquitectura.

### OAuth para autenticación y autorización
#### Ventajas

* Es un estandar altamente empleado, por lo que los principales servicios de autenticación entienden y utilizan OAuth
* Alta compatibilidad y uso. En internet se puede encontrar mucha información relacionada con esta tecnología
* Es altamente seguro. Ya se han tenido en cuenta todos los posibles riesgos de seguridad.

#### Desventajas

* Dificultad para cumplir con todos los requisitos de seguridad para poder emplearlo.
* Muy complejo para principiantes

## Enlaces 

* [JWT vs OAuth][https://geekflare.com/es/jwt-vs-oauth/]


