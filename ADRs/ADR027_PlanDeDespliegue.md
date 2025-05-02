# Plan de Despliegue

- Estado: aceptada
- Responsables: Oier Alduncin, Urki Aristu, Oier Layana, Javier Pernaut y Alexander Sarango
- Fecha: 30/04/2025

Historia técnica: [Issue #77](https://github.com/oielay/GTIO_Votacion/issues/77) [Subissue #80](https://github.com/oielay/GTIO_Votacion/issues/80)

## Contexto y Planteamiento del Problema

El proyecto GTIO_Votacion ha alcanzado un punto en el que requiere un proceso de despliegue automatizado, reproducible y seguro. El objetivo es garantizar que cada nueva versión del sistema (tanto en desarrollo como en producción) pueda desplegarse sin intervención manual, minimizando errores y asegurando la trazabilidad del proceso.

## Factores para la respuesta

- Automatización: El proceso debe ejecutarse sin intervención manual, reduciendo riesgos y aumentando la fiabilidad.
- Reproducibilidad: Cada ejecución debe producir el mismo resultado bajo las mismas condiciones.
- Integración continua y despliegue continuo: Es fundamental que los cambios en las ramas de desarrollo o main desencadenen automáticamente todo el pipeline.

## Respuesta

El plan de despliegue propuesto se basa en una pipeline de CI/CD configurada en GitHub Actions, combinando pruebas automáticas y despliegue de infraestructura con Terraform, junto al empaquetado y publicación de imágenes Docker. De este modo se asegura que cualquier cambio aprobado se valide y despliegue de forma correcta.

### Pipeline de CI/CD con GitHub Actions:

&emsp;&emsp;El pipeline se activa automáticamente al realizar un commit o pull request sobre las ramas desarrollo o main. Esto asegura que todas las versiones significativas del proyecto sean sometidas al proceso de integración y despliegue.

1. **Integración continua (CI)**

   - Incluye los pasos necesarios para validar el código fuente, ejecutar pruebas y verificar el formato y estilo.
   - Se garantiza la calidad y estabilidad antes del despliegue.

2. **Despliegue de infraestructura con Terraform (CD)**

   - Se configuran las credenciales necesarias para operar sobre AWS.
   - Se ejecutan los comandos de Terraform (init, fmt, validate, plan, apply) para desplegar toda la arquitectura.
   - De este modo, se mantiene la infraestructura como código, facilitando la reproducibilidad y auditoría de cambios.

3. **Construcción y publicación de imágenes Docker:**

   - Se construyen las imágenes de Docker correspondientes al frontend y a las APIs.
   - Las imágenes se etiquetan correctamente (docker tag) y se suben a un ECR mediante docker push, dejándolas listas para ser ejecutadas en el entorno de AWS.

En resumen, este plan de despliegue proporciona una solución automatizada y mantenible para el proyecto, alineando el código, la infraestructura y los contenedores en un único flujo controlado.
