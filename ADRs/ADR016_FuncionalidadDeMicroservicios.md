# [Funcionalidad de los microservicios]

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 26/02/2025

Historia técnica: [Issue #50](https://github.com/oielay/GTIO_Votacion/issues/50)


## Contexto y Planteamiento del Problema
Se debe especficiar la funcionalidad que va a tener cada microservicio, de manera que sean independientes, tengan una funcionalidad clara y sean escalables.

## Factores en la Decisión 

* Minimización de responsabilidades
* Independencia de los servicios

## Opciones Consideradas

* Microservicio de candidatos
* Microservicio de usuarios
* Microservicio de autenticación y autorización

## Descripción de las funcionalidades

* Microservicio de candidatos: Se gestiona toda la información relacionada con los participantes. En concreto, se gestiona información personal y los votos que obtienen. Para ello, se ha empleado una API desarrollada en .NET que permite realizar un CRUD
* Microservicios de usuarios: Se gestiona el registro y login de los usuarios. De esta forma se les permite votar y así evitar que puedan repetir el voto. Para ello, se debe desarrollar una nueva API que permita realizar un CRUD.
* Microservicio de autenticacion/autorizacion: Se gestiona el acceso a los endpoints de la API de candidatos. Para que el frontal o software (postman) puedan realizar llamadas a la API de candidatos, es necesario que se registre en este microservicio, que se encargará de devolver un token que tendrá una tiempo de expiración de una hora. Además, el token tiene privilegios de administrador.

## Ventajas y Desventajas de las opciones

### Microservicio de candidatos y usuarios
#### Ventajas

* Se reduce la responsabilidad de cada servicio
* Los servicios son independientes entre si

#### Desventajas

* La arquitectura se vuelve más compleja al tener que emplear muchos servicios

## Enlaces 

* 



