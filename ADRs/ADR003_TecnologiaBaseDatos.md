# Elección de la arquitectura backend: SQL Server 

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 15/02/2025

Historia técnica: [Issue #1](https://github.com/oielay/GTIO_Votacion/issues/1) [Issue #22](https://github.com/oielay/GTIO_Votacion/issues/22)


## Contexto y Planteamiento del Problema
Para almacenar los datos de los candidatos asi como contraseñas y nombres de usuario de los administradores, es necesario elegir un servidor de base de datos en base al rendimiento, la escalabilidad, compatibilidad y la cantidad de información que exista de esa herramienta.

## Factores en la Decisión 

* Compatibilidad
* Escalabilidad
* Precio
* Información

## Opciones Consideradas

* SQL Server
* MySQL
* MongoDB

## Decisión

Se ha decidido emplear como servidor de base de datos SQLServer. Esto se debe a que SQLServer está integrado en .NET lo que facilita la creación de las bases de datos y evita la instalación de otras bibliotecas. Además es compatible con EntityFramework Core que es la tecnología que emplea .NET para trabajar con objetos sin tener que realizar sentencias SQL. Por otro lado, al ser una tecnología de microsoft, permite aprovechar todo el entorno, como Microsoft Azure, Visual Studio, entre otros.

## Ventajas y Desventajas de las opciones

### MySQL
#### Ventajas

* Se puede emplear en multiples sistemas operativos como Linux, Windows y MacOS
* Es gratis. La edición empresarial puede tener un costo
* Es compatible con muchas plataformas

#### Desventajas
* Ofrece sistemas de seguridad menos avanzados
* Menos eficiente conforme aumenta la carga de trabajo (menos escalable)

### MongoDB
#### Ventajas
* Flexibilidad en el modelo de datos. Puede modificar la estructura de los datos en cualquier momento, a diferencia de las bases de datos no relacionales
* Puede escalar horizontalmente a otros servidores para aumentar el tamaño de la base de datos. De esta forma no necesita aumentar el rendimiento de su entorno
* Es gratis

#### Desventajas
* Poco eficiente cuando las consultas son demasiado complejas
* Consistencia eventual. Los datos replicados en un nodo pueden no tener valores correctos.
* Dificultad para realizar joins de consultas

### SQL Server

#### Ventajas
* Es adecuado para empresas con requisitos mas complejos
* Ofrece sistemas de seguridad avanzadas como el cifrado de datos transparente
* Es mas eficiente conforme aumenta la carga de trabajo (escalabilidad)
* Tiene mayor compatibilidad con el entorno de microsoft
* Se puede emplear Entity FrameWork Core para facilitar las consultas a la base de datos, desde .NET


#### Desventajas
* Está diseñado principalmente para ejecutarse en Windows
* mas costoso
* No es compatible con muchas plataformas


## Enlaces 

* [Ventajas y desventajas MySQL y SQL Server][https://www.astera.com/es/knowledge-center/mysql-sql-server/]
* [Ventajas y desventajas MongoDB][https://www.dongee.com/tutoriales/ventajas-y-desventajas-de-mongodb/]


