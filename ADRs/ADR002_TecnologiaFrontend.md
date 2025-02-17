# Elección de la herramienta para el desarrollo del frontend: Astro

* Estado: aceptada
* Responsables: Oier Layana, Urki Aristu
* Fecha: 07/02/2025

Historia técnica: [Issue #1](https://github.com/oielay/GTIO_Votacion/issues/1) [Subissue #15](https://github.com/oielay/GTIO_Votacion/issues/15)

## Contexto y Planteamiento del Problema

Se necesita elegir la tecnología que se utilizará para el desarrollo del frontend, ya que esto influirá en la estructura, rendimiento y optimización del proyecto. Además, el frontend deberá realizar peticiones fetch para obtener información de la API.

## Factores en la Decisión

* Optimización en el rendimiento
* Facilidad de integración con el backend
* SEO y optimización para SSR
* Familiaridad con la tecnología
* Soporte para realizar peticiones a la API

## Opciones Consideradas

* Astro
* React
* Vue.js
* Next.js
* SvelteKit

## Decisión

Se ha elegido desarrollar el frontend en Astro debido a su capacidad para generar páginas estáticas altamente optimizadas, lo que mejora el rendimiento y el SEO. Además, permite la integración con múltiples frameworks como React y Vue cuando sea necesario. Astro también facilita la carga diferida de componentes interactivos, lo que reduce el consumo de recursos en el cliente. Su enfoque en la optimización del rendimiento lo convierte en una excelente opción para el proyecto. También cuenta con soporte para realizar fetch a la API y manejar datos dinámicos cuando sea necesario.

## Ventajas y Desventajas de las Opciones

### Astro

[Más información](https://astro.build/)

#### Ventajas

* Generación de sitios estáticos optimizados por defecto
* Soporte para múltiples frameworks (React, Vue, Svelte, etc.)
* Carga diferida de componentes interactivos
* Excelente rendimiento y SEO
* Bajo consumo de recursos en el cliente
* Soporte para fetch y consumo de APIs
* Familiaridad

#### Desventajas

* Comunidad más pequeña en comparación con React o Vue
* Menos bibliotecas y plugins disponibles
* No tan adecuado para aplicaciones completamente interactivas

### React

[Más información](https://react.dev/)

#### Ventajas

* Gran comunidad y ecosistema maduro
* Reutilización de componentes y desarrollo eficiente
* Compatible con SSR a través de Next.js
* Soporte a largo plazo

#### Desventajas

* Requiere más optimización para el rendimiento en SSR
* Mayor tiempo de carga en comparación con Astro para contenido estático
* Curva de aprendizaje más pronunciada para optimización avanzada

### Vue.js

[Más información](https://vuejs.org/)

#### Ventajas

* Sintaxis simple y orientada a componentes
* SSR disponible con Nuxt.js
* Buen equilibrio entre rendimiento y facilidad de uso
* Comunidad activa
* Familiaridad

#### Desventajas

* Menos utilizado en grandes aplicaciones en comparación con React
* Rendimiento ligeramente inferior a Astro para contenido estático

### Next.js

[Más información](https://nextjs.org/)

#### Ventajas

* Generación de páginas estáticas y SSR
* Integración nativa con React
* Excelente optimización para SEO
* Gran ecosistema y soporte de Vercel

#### Desventajas

* Mayor complejidad en comparación con Astro
* Tiempo de construcción más largo para sitios estáticos grandes
* Overhead innecesario si no se requiere mucha interactividad

### SvelteKit

[Más información](https://kit.svelte.dev/)

#### Ventajas

* Código más simple y eficiente
* Excelente rendimiento sin necesidad de runtime
* SSR y generación de sitios estáticos soportados

#### Desventajas

* Comunidad y ecosistema más pequeños
* Menos soporte empresarial que React o Vue
* Menos bibliotecas disponibles