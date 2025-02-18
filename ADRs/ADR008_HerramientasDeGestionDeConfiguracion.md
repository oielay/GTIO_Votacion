# [Elección de la herramienta de gestión de la configuración]

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango
* Fecha: 15/02/2025

Historia técnica: [Issue #18](https://github.com/oielay/GTIO_Votacion/issues/18)


## Contexto y Planteamiento del Problema
Es necesario realizar la gestión de la configuración de los servicios para garantizar que funcionan correctamente en diferentes entornos y en cualquiera de las etapas de desarrollo. Esto permite crear sistemas sólidos y estables. 
De esta forma, la gestión de la configuración nos permite supervisar y controlar los cambios de configuración de los sistemas software.

## Factores en la Decisión 

* Poder controlar las versiones
* Poder controlar los cambios que se realizan sobre el código
* Poder disponer de las versiones estables
* Automatización de CI (integración continua) y CD (distribución continua - pruebas y despliegue)
* Poder aplicar la metodología Kanban
* Precio
* Almacenamiento disponible

## Opciones Consideradas 

* GitHub
* Azure DevOps
* GitLab

## Decisión

Se ha decidido emplear GitHub para realizar el control de versiones, realizar CI/CD, llevar a cabo la metodología Kanban, disponer de todo el histórico de cambios y las versiones estableces del producto (Tags), asi como de su documentación (wiki).

## Ventajas y Desventajas de las opciones

### GitLab
#### Ventajas

* Permite crear repositorios públicos y privados de forma ilimitada

#### Desventajas

* No tiene una comunidad muy grande
* Precio
* Tiene un almacenamiento limitado de 5GB para repositórios públicos

### azure DevOps
#### Ventajas

* Asistencia técnica
* Escalabilidad ya que está alojado en la nube
* Está integrado con otros servicios de Microsoft como Azure

#### Desventajas

* Aprendizaje poco intuitivo
* Precio 2 a 10 GB, cuesta 2 Euros cada giga.

### GitHub
#### Ventajas

* Tiene una comunidad muy grande
* Almacenamiento ilimitado para repositorios públicos

#### Desventajas

* Tiene limitaciones en el tamaño de los archivos que se pueden subir (100MB)


## Enlaces 

* [Gestión de la configuración][https://www.atlassian.com/es/microservices/microservices-architecture/configuration-management]
* [Ventajas y desventajas GitLab y GitHub][https://blog.desdelinux.net/github-vs-gitlab/]
* [Ventajas y desventajas GitLab y GitHub][https://gitprotect.io/blog/github-storage-limits/#:~:text=The%20storage%20limit%20for%20GitHub,both%20private%20and%20public%20repositories.]
* [Ventajas y desventajas Azure DevOps][https://elrincondemorta.wordpress.com/2020/10/25/azure-ventajas-y-desventajas/]
* [Gestión de la configuración, ejemplos][https://www.itgov-docs.com/blogs/it-governance/configuration-management]

