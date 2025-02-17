# Elección de la herramienta para el desarrollo del backend: ASP.NET Core

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 12/02/2025

Historia técnica: [Issue #1](https://github.com/oielay/GTIO_Votacion/issues/1) [Subissue #14](https://github.com/oielay/GTIO_Votacion/issues/14)

## Contexto y Planteamiento del Problema

Se necesita elegir la tecnología que se utilizará para el desarrollo del backend ya que esto permitirá elegir otras tecnologías necesarias para este desarrollo.

## Factores en la Decisión 

* Familiarización con el entorno
* Documentación en internet
* Rendimiento
* Escalabilidad

## Opciones Consideradas

* ASP.NET Core
* Django
* Laravel
* Node.js
* Ruby on Rails

## Decisión

Se ha elegido desarrollar el backend en .NET debido a la familiarización que el equipo tiene con esta herramienta. Además, tiene un alto rendimiento en comparación con otras tecnologías mencionadas. Asmimismo, tiene seguridad integrada frente a varios tipos de ataques, es open-source y es compatible con tecnologías como docker para despliegues en la nube. Aunque la curva de aprendizaje es mayor, no afectará a nuestro desarrollo ya que se conoce previamente la tecnología.

## Ventajas y Desventajas de las opciones

### ASP.NET Core

[Más información](https://dotnet.microsoft.com/es-es/learn/aspnet/what-is-aspnet-core)

#### Ventajas

* Alto rendimiento y eficiencia con Kestrel
* Seguridad avanzada integrada
* Multiplataforma (Windows, Linux, macOS)
* Gran integración con Azure y Microsoft
* Soporte nativo para microservicios y contenedores
* Open-source y mantenimiento a largo plazo

#### Desventajas

* Curva de aprendizaje mayor (C# y .NET)
* Mayor consumo de memoria en entornos pequeños
* Comunidad más orientada a empresas que a startups

### Django

[Más información](https://www.djangoproject.com/)

#### Ventajas

* Rápido desarrollo con arquitectura "batteries included"
* Seguridad robusta por defecto
* Gran comunidad y documentación extensa
* ORM potente y fácil de usar
* Escalabilidad adecuada para aplicaciones medianas

#### Desventajas

* Rendimiento menor comparado con otras opciones
* Más rígido y monolítico en comparación con frameworks modernos
* No tan eficiente para microservicios como otras alternativas

### Laravel

[Más información](https://laravel.com/)

#### Ventajas

* Sintaxis elegante y orientada a productividad
* Gran ecosistema con herramientas como Eloquent y Forge
* Seguridad integrada con autenticación y protección CSRF
* Comunidad activa y buena documentación
* Compatible con MySQL, PostgreSQL, SQLite y SQL Server

#### Desventajas

* Rendimiento menor comparado con Node.js y ASP.NET Core
* No es la mejor opción para microservicios
* Requiere más optimización para aplicaciones a gran escala

### Node.js

[Más información](https://nodejs.org/es)

#### Ventajas

* Alto rendimiento con procesamiento asíncrono
* Gran ecosistema con NPM
* Ideal para aplicaciones en tiempo real (WebSockets)
* Compatible con arquitecturas serverless y microservicios
* Comunidad activa y en constante evolución

#### Desventajas

* Seguridad más vulnerable si no se gestionan bien dependencias
* Callback hell y problemas de asincronía en código mal estructurado
* Monohilo, lo que puede ser un problema en tareas CPU-intensivas

### Ruby on Rails

[Más información](https://rubyonrails.org/)

#### Ventajas

* Desarrollo rápido con convención sobre configuración
* Gran comunidad y muchas gemas disponibles
* Buenas herramientas para pruebas automatizadas
* Código limpio y mantenible con MVC
* Soporte incorporado para seguridad y autenticación

#### Desventajas

* Rendimiento inferior a otras opciones como Node.js y ASP.NET Core
* Menos popular en nuevos proyectos
* Consumo de recursos más alto en comparación con frameworks modernos
