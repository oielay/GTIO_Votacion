# Buenas prácticas frontend

* Estado: aceptada
* Responsables: Oier Layana, Urki Aristu
* Fecha: 16/03/2025

Historia técnica: [Issue #51](https://github.com/oielay/GTIO_Votacion/issues/51) [Subissue #53](https://github.com/oielay/GTIO_Votacion/issues/53)

## Contexto y Planteamiento del Problema

Para abordar la problemática de malas prácticas, se propone la integración de un sistema de linting automático dentro del flujo de integración continua (CI) mediante GitHub Actions. Esto permitirá detectar y corregir malas prácticas en el código antes de que se fusionen cambios en la rama principal del proyecto.

## Factores en la Decisión 

* Sencillez de correción de errores
* Mantenibilidad del código
* Tamaño actual del proyecto pequeño

## Opciones Consideradas para Astro

* no-set-html-directive
* no-unused-css-selector
* no-inline-styles
* no-unused-components

## Decisión Astro

Se ha decicido usar no-set-html-directive y no-unused-css-selector puesto que nos han parecido dos reglas bastante sencillas de corregir y que aportaban buenas prácticas al proyecto. Aunque no descartamos usar otras opciones a medida que el proyecto vaya creciendo y sean necesarias mas buenas prácticas.

## Ventajas y Desventajas de las opciones para Astro

### no-set-html-directive

#### Ventajas
- Fomenta la consistencia en el código, evitando la adición innecesaria de directivas HTML, lo que puede hacer que el código sea más limpio y fácil de mantener.

- Ayuda a prevenir errores de configuración al forzar que las directivas de HTML sean declaradas de manera explícita.

- Mejora la accesibilidad y la semántica del código

#### Desventajas
- Puede requerir una reconfiguración si el proyecto cambia la manera de trabajar con las directivas HTML.

### no-unused-css-selector

#### Ventajas
- Elimina el código CSS no utilizado, reduciendo el tamaño de los archivos CSS y mejorando el rendimiento de la página.

- Hace que el código sea más limpio y fácil de mantener, ya que elimina reglas innecesarias que podrían causar confusión en el futuro.

#### Desventajas
- Puede generar advertencias si se utiliza CSS dinámico.

- Si no se configura correctamente, puede eliminar selectores que aún no se están utilizando activamente pero que se utilizarán más adelante en el desarrollo.
### no-inline-styles

#### Ventajas
- Promueve la separación de responsabilidades entre el HTML y los estilos CSS, haciendo que el código sea más organizado y fácil de mantener.

#### Desventajas
- Requiere refactorización de algunos elementos que usan estilos en línea, lo que puede aumentar el tiempo de desarrollo al principio.

- Puede ser difícil de implementar en componentes de estilo dinámico.

### no-unused-components

#### Ventajas
- Elimina componentes no utilizados, lo que reduce el tamaño del proyecto y mejora el rendimiento.

- Facilita la organización y mantenimiento del código al eliminar partes del mismo que no están en uso.

#### Desventajas
- Si no se configura correctamente, puede eliminar componentes que se usarán más adelante, lo que podría causar errores en el proyecto.

- El proyecto actualemnte no es muy grande por lo que hay pocos componentes y son creados en el momento que son necesarios.

## Opciones Consideradas para Typescript

* no-unused-vars
* no-var-requires
* no-require-imports
* explicit-function-return-type

## Decisión Typescript

Se ha decicido usar no-unused-vars, no-var-requires y no-require-imports para garantizar un código más limpio, evitando variables innecesarias y promoviendo el uso coherente del sistema de módulos.

## Ventajas y Desventajas de las opciones de Typescript

### no-unused-vars

#### Ventajas
- Mejora la calidad del código al eliminar las variables que no se utilizan, reduciendo la complejidad.

- Al reducir el número de variables innecesarias, facilita el mantenimiento del código y mejora la legibilidad.

#### Desventajas
- Puede generar advertencias en código que podría estar en desarrollo, como variables declaradas que aún no se usan pero se planean usar más adelante.

### no-var-requires

#### Ventajas
- Promueve el uso de la sintaxis `import` en lugar de `require`, lo que es más compatible con la modularidad moderna de ES6+.

- Facilita la compatibilidad con herramientas y librerías modernas que requieren módulos ES.

#### Desventajas
- Si el código base utiliza la sintaxis `require` ampliamente, forzar el cambio podría ser tedioso y requerir mucho esfuerzo de refactorización.

### no-require-imports

#### Ventajas
- Impide el uso de `require` para importar módulos, lo que obliga a usar la sintaxis `import` que es más adecuada para la compatibilidad futura y más alineada con las mejores prácticas de JavaScript moderno.

- Ayuda a mantener el código más consistente y fácil de seguir al evitar la mezcla de diferentes estilos de importación.

#### Desventajas
- La transición desde `require` a `import` puede ser tediosa si ya hay muchas dependencias en el proyecto que usan `require`.

### explicit-function-return-type

#### Ventajas
- Garantiza que todas las funciones tengan un tipo de retorno explícito, lo que mejora la claridad del código y facilita la detección de errores.

- Facilita el mantenimiento del código a largo plazo, ya que hace que los tipos sean más explícitos y claros para otros desarrolladores.

#### Desventajas
- Requiere más tiempo de desarrollo al añadir la declaración del tipo de retorno en todas las funciones, lo cual puede ser innecesario en funciones simples.
