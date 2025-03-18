# Buenas prácticas Backend

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alducin y Alex Sarango.
* Fecha: 16/03/2025

Historia técnica: [Issue #51](https://github.com/oielay/GTIO_Votacion/issues/51) [Subissue #52](https://github.com/oielay/GTIO_Votacion/issues/52)

## Contexto y Planteamiento del Problema

Para abordar la problemática de malas prácticas, se propone la integración de un sistema de linting automático dentro del flujo de integración continua (CI) mediante GitHub Actions. Esto permitirá detectar y corregir malas prácticas en el código antes de que se fusionen cambios en la rama principal del proyecto. Además también se ha empleado una herramienta llamada Swagger para mantener una correcta documentación de las APIs.

## Linting

### Factores en la Decisión 

* Consistencia del Código.
* Configuración Flexible.
* Integración con el Proceso de Construcción.

### Opciones Consideradas

* StyleCop
* SonarLint

### Decisión StyleCop

Aunque sí que es cierto que SonarLint es una aplicación más versatil y que soporta una mayor cantidad de lenguajes, StyleCop es justo lo que necesitamos. Simplemente con la configuración por defecto nos permite corregir el código directamente en el proceso de construcción lo que ayuda mucho a mantener el código en las mejores condiciones en todo momento.

### Ventajas y Desventajas de las opciones

#### StyleCop

##### Ventajas
- Consistencia del Código: Mantiene un estilo de código consistente, especialmente en C#.
- Configuración Flexible: Permite personalizar las reglas de estilo según las necesidades del equipo.
- Integración con el Proceso de Construcción: Detecta problemas de estilo antes de fusionar el código.
- Fácil de Usar: Al integrarlo con el proceso de construcción no requiere nada más.

##### Desventajas
- Limitado a C#: Principalmente útil para proyectos en C# lo cual se ajusta a nuestras necesidades.
- Menos Enfoque en Seguridad: No se centra tanto en la detección de vulnerabilidades.
- Menos Versátil: No soporta múltiples lenguajes.

#### SonarLint

##### Ventajas
- Multilenguaje: Soporta múltiples lenguajes de programación.
- Análisis en Tiempo Real: Detecta problemas mientras escribes el código.
- Enfoque en Seguridad: Identifica vulnerabilidades y problemas de seguridad.
- Integración con SonarQube: Ofrece informes avanzados y una visión completa de la calidad del código.
- Correcciones Rápidas: Sugerencias inteligentes para solucionar problemas detectados.

##### Desventajas
- Configuración Compleja: Puede requerir más configuración para personalizar las reglas.
- Menos Enfoque en Estilo: Aunque tiene reglas de estilo, no está tan centrado en la consistencia del código como StyleCop.

### Conclusión
SonarLint es una herramienta versátil que ofrece análisis en tiempo real, soporte para múltiples lenguajes y un enfoque fuerte en la seguridad del código. Por otro lado, StyleCop se especializa en mantener la consistencia del estilo de código en proyectos C#, con una configuración flexible y una integración sencilla en el proceso de construcción.

En resumen, para un proyecto pequeño y centrado en C#, StyleCop ofrece una solución eficiente y específica que ayudará a mantener la calidad y consistencia del código sin complicaciones adicionales.

## Tests
### Decisión Dotnet

Como hemos comentado, el problema de linting se ha solucionado empleando StyleCop en el momento de compilación del código. Esto se hace mediante un paquete llamado DotNet. Además de añadir esa regla de estilo, el propio paquete nos permite ejecutar las pruebas unitarias que hayamos creado. Es por esto que DotNet ha sido nuestra principal opción para solventar esta necesidad. Al estar directamente relacionados, no se han tenido que considerar otras opciones.

## Inclusión de Swagger para la Documentación de Nuestras APIs
Para mejorar la documentación y la usabilidad de nuestras APIs, hemos integrado Swagger. Con Swagger, los desarrolladores pueden ver y probar las peticiones disponibles que ofrece nuestra API directamente desde una interfaz web interactiva.

Esta herramienta no solo facilita la comprensión de los endpoints y sus funcionalidades, sino que también permite a los usuarios realizar pruebas de las peticiones en tiempo real. Esto es especialmente útil para los desarrolladores que necesitan verificar el comportamiento de la API sin tener que escribir código adicional.

La inclusión de Swagger en nuestro proyecto nos proporciona los siguientes beneficios:

- Documentación Automática: Swagger genera automáticamente la documentación de la API a partir del código fuente, asegurando que siempre esté actualizada.
- Interfaz Interactiva: Los usuarios pueden explorar y probar los endpoints de la API directamente desde la interfaz de Swagger.
- Mejora de la Colaboración: Facilita la colaboración entre equipos de desarrollo, ya que todos tienen acceso a una documentación clara y precisa.
- Ahorro de Tiempo: Al permitir pruebas directas desde la documentación, se reduce el tiempo necesario para verificar y depurar las peticiones.

En resumen, la integración de Swagger en nuestro flujo de trabajo mejora significativamente la experiencia de desarrollo y la calidad de nuestras APIs, asegurando que sean fáciles de entender y utilizar.
