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

1.  **Integración continua (CI)**

    - Incluye los pasos necesarios para validar el código fuente, ejecutar pruebas y verificar el formato y estilo.
    - Se garantiza la calidad y estabilidad antes del despliegue.

2.  **Despliegue continuo (CD)**

    - Despliegue de repositorios ECR con Terraform (CD)

      - Se configuran las credenciales necesarias para operar sobre AWS.
      - Se ejecuta terraform apply con `-target=module.ecr` para desplegar exclusivamente los repositorios de contenedores (ECR).
      - Esto asegura que las imágenes Docker puedan ser construidas y subidas a un destino válido antes de provisionar más infraestructura.

    - Construcción y publicación de la imagen de la API

      - Se construye la imagen Docker de la API mediante `docker-compose`.
      - Se etiqueta apropiadamente con `docker tag` y se sube al repositorio ECR correspondiente mediante `docker push`.

    - Despliegue del resto de la infraestructura (sin incluir el frontend)

      - Se aplica Terraform sobre los módulos necesarios para crear la infraestructura general del backend y los servicios relacionados con la API (balanceadores, tareas, bases de datos, etc.), excluyendo el servicio del frontend.
      - Esto permite que la API esté disponible para posteriores tareas automatizadas, como el poblamiento de la base de datos.

    - Poblamiento de la base de datos

      - Se realiza una petición HTTP POST hacia un endpoint de la API que crea y rellena la base de datos.
      - El sistema espera automáticamente a que la API esté accesible antes de realizar esta operación, reintentando hasta que sea exitoso.

    - Construcción y publicación de la imagen del frontend

      - Se construye la imagen del frontend usando `docker-compose`.
      - Luego se etiqueta y se publica en el ECR correspondiente.

    - Despliegue del servicio de frontend

      - Finalmente, se aplica Terraform exclusivamente al módulo que crea el servicio del frontend (`-target=module.frontend`).
      - Esto completa el despliegue de la aplicación, garantizando que la base de datos ya está poblada y el frontend puede acceder a toda la infraestructura funcional.

### Obtención de variables desde S3

Además de obtener el código fuente y los archivos de configuración desde el repositorio, el flujo CI/CD también recupera desde un bucket de Amazon S3 tanto:

- Las variables de entorno necesarias para la ejecución del sistema (por ejemplo, claves API, configuraciones de entorno para staging o producción, etc.).
- Los archivos de variables de Terraform (\*.tfvars) que definen parámetros clave como regiones, nombres de recursos, tamaños de instancias, entre otros.

Esto permite desacoplar la configuración sensible o específica del entorno del código fuente y facilita su gestión centralizada y segura. El acceso al bucket está restringido mediante políticas IAM para garantizar que solo los workflows autorizados puedan obtener dicha información.

### Resumen del Plan de Despliegue

Se ha diseñado un proceso de despliegue automatizado para el proyecto GTIO_Votacion utilizando GitHub Actions, Docker y Terraform. El pipeline realiza integración y despliegue continuo (CI/CD), asegurando que cada cambio en las ramas principales active automáticamente validaciones, construcción de imágenes y provisión de infraestructura en AWS. Se divide en fases para desplegar primero la API, poblar la base de datos y, finalmente, desplegar el frontend. Además, el flujo obtiene de un bucket de Amazon S3 tanto variables de entorno como archivos de configuración de Terraform, centralizando la gestión de secretos y parámetros críticos de despliegue. Esto garantiza un proceso reproducible, seguro y sin intervención manual.

### Enlaces

Para poder seguir el flujo que sigue la integración continua y el despliegue continuo, con todos los comandos necesarios para ejecutarse de forma adecuada, se puede consultar cualquiera de los dos siguientes enlaces:

- [README](https://github.com/oielay/GTIO_Votacion?tab=readme-ov-file#gtio_votacion)
- [GitHub Actions](https://github.com/oielay/GTIO_Votacion/blob/main/.github/workflows/ci-cd.yml)
