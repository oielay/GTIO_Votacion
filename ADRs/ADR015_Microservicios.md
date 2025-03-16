# [Definición de Microservicios]

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 26/02/2025

Historia técnica: [Issue #49](https://github.com/oielay/GTIO_Votacion/issues/49)


## Contexto y Planteamiento del Problema
Para desarrollar toda la arquitectura, es necesario definir cuales serán los microservicios por los que estará formado. Con esto se pretende separar responsabilidades. De esta forma el sistema será mas escalable y un único servicio no cargará con tanta responsabilidad.

## Factores en la Decisión 

* Minimización de responsabilidades
* Independencia entre microservicios

## Opciones Consideradas

* Microservicio de candidatos
* Microservicio de usuarios
* Microservicio de comentarios

## Decisión

Se ha decidido tener en cuenta un servicio de candidatos y un servicio de usuarios para registrar los votos que se realizan a cada uno de los candidatos y evitar que un usuario vote varias veces.

## Ventajas y Desventajas de las opciones

### Microservicio de candidatos y usuarios
#### Ventajas

* Se reduce la responsabilidad de cada servicio
* Los servicios son independientes entre si, por lo que se pueden escalar fácilmente

#### Desventajas

* El microservicio de candidatos, gestiona la información de los candidatos asi como los votos. Dependiendo de cómo crezca la aplicación, pueden llegar a separarse.

### Microservicio de candidatos, usuarios y comentarios
#### Ventajas

* La página web tiene mas funcionalidades (se añade el microservicio de comentarios), lo que la hace más atractiva para los usuarios.

#### Desventajas

* Se requiere mucho tiempo para su desarrollo

## Enlaces 

*



