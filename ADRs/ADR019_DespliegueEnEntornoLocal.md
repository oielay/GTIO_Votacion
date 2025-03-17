# Despliegue en Entorno de Test Local

- Estado: aceptada
- Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana
- Fecha: 26/02/2025

Historia técnica: [Issue #56](https://github.com/oielay/GTIO_Votacion/issues/56)

## Contexto

Se requiere definir un método para desplegar la aplicación en un entorno local de pruebas, para que el equipo de desarrollo pueda realizar pruebas consistentes antes de pasar a entornos de producción. Las opciones deben ser evaluadas según la facilidad de configuración, rendimiento y replicabilidad del entorno de producción.

## Factores en la Decisión

- Facilidad de configuración y uso
- Rendimiento y velocidad
- Replicabilidad del entorno de producción
- Integración con CI/CD
- Compatibilidad con el stack tecnológico

## Opciones Consideradas

- Despliegue manual con npm
- Docker
- Vagrant
- Ngrok

## Decisión

Actualmente, el proyecto ya está dockerizado, lo que nos permite utilizar **Docker** junto con **docker-compose** para gestionar el despliegue en el entorno de test local. Este enfoque asegura que todos los servicios necesarios se levanten simultáneamente y que el entorno de pruebas sea lo más similar posible al de producción. Además, facilita la replicabilidad, el aislamiento de dependencias y la integración con el proceso de CI/CD activo con GitHub Actions.

## Ventajas y Desventajas de las Opciones

### Despliegue manual con npm

[Más información](https://www.npmjs.com/)

#### Ventajas

- Fácil de configurar y usar para proyectos pequeños.
- Requiere menos recursos y puede ser más rápido de configurar en equipos pequeños.
- Opción asequible para proyectos no dockerizados.

#### Desventajas

- No replica fielmente el entorno de producción, lo que puede generar inconsistencias.
- No es escalable si el proyecto crece y necesita simular múltiples servicios o entornos.

### Docker

[Más información](https://www.docker.com/)

#### Ventajas

- Permite replicar exactamente el entorno de producción.
- Facilita la integración continua (CI/CD) en el proceso de pruebas.
- Aísla las dependencias y servicios del sistema operativo del desarrollador.

#### Desventajas

- Puede requerir una configuración inicial más compleja.
- Requiere tener Docker instalado y configurado en cada máquina de desarrollo.

### Uso de Vagrant

[Más información](https://www.vagrantup.com/)

#### Ventajas

- Permite crear entornos virtualizados replicables en diferentes sistemas operativos.
- Ideal para equipos que necesitan máquinas virtuales para simular el entorno de producción.

#### Desventajas

- Configuración más pesada comparada con Docker.
- Mayor uso de recursos y menor flexibilidad en comparación con Docker.

### Entorno virtual con servicios como ngrok

[Más información](https://ngrok.com/)

#### Ventajas

- Útil para exponer servidores locales a la web de forma temporal.
- Rápido de configurar para compartir pruebas con otros de manera sencilla.

#### Desventajas

- No es adecuado para crear un entorno completo de test, más bien para pruebas puntuales.
- Dependencia de servicios externos, lo que podría afectar la disponibilidad de las pruebas.
## Pasos para el despliegue local (con Docker y docker-compose)

1. **Configurar variables de entorno:**  
    Situar el archivo `.env` en la raíz del proyecto y configurar las variables de entorno requeridas.

2. **Construir y levantar los servicios:**  
    Ejecutar el comando `docker-compose up --build` para construir las imágenes y levantar los servicios definidos en el archivo `docker-compose.yml`.

3. **Acceder al servicio deseado:**  
    Una vez que los contenedores estén en ejecución, abrir el navegador en los siguientes puertos en base al servicio que se quiera acceder:
    - `http://localhost:1234` para la aplicación web.
    - `http://localhost:5000/swagger/` para la API de candidatos.
    - `http://localhost:1433` para la base de datos SQL Server.
    - `http://localhost:8000` (o también en los puertos 8001, 8002, 8443 y 8444) para Kong.
    - `http://localhost:9090` para prometheus.

## Consecuencias

- **Docker y docker-compose** serán la opción estándar para los despliegues de test locales, asegurando un entorno replicable y consistente con producción.
- Los desarrolladores deben seguir este procedimiento para levantar el entorno de pruebas local.
- La documentación deberá mantenerse actualizada conforme se realicen cambios en la configuración de Docker o en los servicios utilizados.
- Este enfoque facilita la integración con CI/CD y el aislamiento de dependencias, mejorando la calidad y consistencia de las pruebas.
