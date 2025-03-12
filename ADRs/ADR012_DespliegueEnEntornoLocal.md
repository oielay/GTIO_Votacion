# Despliegue en Entorno de Test Local

* Estado: aceptada  
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana  
* Fecha: 18/02/2025

Historia técnica: [Issue #6](https://github.com/oielay/GTIO_Votacion/issues/6)  

## Contexto  
Se requiere definir un método para desplegar la aplicación en un entorno local de pruebas, para que el equipo de desarrollo pueda realizar pruebas consistentes antes de pasar a entornos de producción. Las opciones deben ser evaluadas según la facilidad de configuración, rendimiento y replicabilidad del entorno de producción.

## Factores en la Decisión  
* Facilidad de configuración y uso
* Rendimiento y velocidad 
* Replicabilidad del entorno de producción
* Integración con CI/CD
* Compatibilidad con el stack tecnológico

## Opciones Consideradas  
* Despliegue manual con npm
* Docker
* Vagrant
* Ngrok  

## Decisión  
Actualmente, el proyecto no está dockerizado, por lo que el despliegue en el entorno de test local se hará manualmente utilizando **npm**. Este enfoque permite comenzar rápidamente sin necesidad de configuraciones adicionales. Sin embargo, dado que el proyecto crecerá y requerirá un entorno más replicable y consistente, en el futuro se implementará **Docker** para asegurar que los entornos de prueba sean lo más similares posibles al de producción.

## Ventajas y Desventajas de las Opciones

### Despliegue manual con npm  

[Más información](https://www.npmjs.com/)  

#### Ventajas  

* Fácil de configurar y usar para proyectos pequeños.  
* Requiere menos recursos y puede ser más rápido de configurar en equipos pequeños.  
* Opción asequible para proyectos no dockerizados.  

#### Desventajas  

* No replica fielmente el entorno de producción, lo que puede generar inconsistencias.  
* No es escalable si el proyecto crece y necesita simular múltiples servicios o entornos.  

### Docker  

[Más información](https://www.docker.com/)  

#### Ventajas  

* Permite replicar exactamente el entorno de producción.  
* Facilita la integración continua (CI/CD) en el proceso de pruebas.  
* Aísla las dependencias y servicios del sistema operativo del desarrollador.  

#### Desventajas  

* Puede requerir una configuración inicial más compleja.  
* Requiere tener Docker instalado y configurado en cada máquina de desarrollo.  

### Uso de Vagrant  

[Más información](https://www.vagrantup.com/)  

#### Ventajas  

* Permite crear entornos virtualizados replicables en diferentes sistemas operativos.  
* Ideal para equipos que necesitan máquinas virtuales para simular el entorno de producción.  

#### Desventajas  

* Configuración más pesada comparada con Docker.  
* Mayor uso de recursos y menor flexibilidad en comparación con Docker.  

### Entorno virtual con servicios como ngrok  

[Más información](https://ngrok.com/)  

#### Ventajas  

* Útil para exponer servidores locales a la web de forma temporal.  
* Rápido de configurar para compartir pruebas con otros de manera sencilla.  

#### Desventajas  

* No es adecuado para crear un entorno completo de test, más bien para pruebas puntuales.  
* Dependencia de servicios externos, lo que podría afectar la disponibilidad de las pruebas.


## Pasos para el despliegue local (con npm)

1. **Instalar dependencias:**  
   Ejecutar `npm install` para instalar las dependencias del proyecto.

2. **Ejecutar la aplicación:**  
   Iniciar la aplicación con `npm run dev`.

3. **Acceder a la aplicación:**  
   Abrir el navegador y acceder a `http://localhost:4321` para realizar las pruebas en el entorno local.

## Consecuencias  
- **npm** será la opción estándar para los despliegues de test locales mientras el proyecto no esté dockerizado.  
- Los desarrolladores deben seguir este procedimiento de despliegue manual utilizando npm.  
- En el futuro, cuando se decida dockerizar el proyecto, se cambiará el procedimiento para usar **Docker** y se ajustarán los pasos correspondientes para facilitar la replicabilidad del entorno de pruebas.  
- Es probable que se necesiten actualizaciones en la documentación conforme evolucionen las herramientas utilizadas.  
