# Despliegue en Entorno Local

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana
* Fecha: 13/02/2025
Historia técnica: [Issue #6](https://github.com/oielay/GTIO_Votacion/issues/6) 

## Contexto
Para facilitar el desarrollo y las pruebas de la aplicación, es necesario definir un proceso claro y estructurado para el despliegue en entorno local. Esto garantizará que todos los desarrolladores puedan trabajar de manera consistente y minimizar problemas de configuración.

## Opciones Consideradas

* Composer
* Node.js

## Decisión
Se establece un procedimiento estándar para desplegar la aplicación en un entorno local, utilizando Node.js como herramienta principal, ya que Astro depende de Node.js para la instalación de paquetes y la ejecución del servidor de desarrollo. No hay una alternativa viable sin Node.js, dado que su CLI y herramientas requieren este entorno. En el futuro, se podría considerar la integración con Docker o servicios de CI/CD para mejorar la gestión del entorno

## Pasos para el despliegue local
1. Instalar dependencias:
    - Ejecutar `npm install` para instalar las dependencias del proyecto.

2. Ejecutar la aplicación:
    - Iniciar la aplicación con `npm run dev`.

## Consecuencias

- Todos los desarrolladores deberán seguir este procedimiento.

- Puede ser necesario actualizar la documentación conforme evolucionen las herramientas utilizadas.