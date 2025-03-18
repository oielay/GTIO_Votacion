# Tests de funcionalidades frontend en entorno local

* Estado: aceptada
* Responsables: Urki Aristu, Oier Layana
* Fecha: 16/02/2025

Historia técnica: [Issue #57](https://github.com/oielay/GTIO_Votacion/issues/57) [Subissue #59](https://github.com/oielay/GTIO_Votacion/issues/59)

## Contexto y Planteamiento del Problema

En el marco de desarrollo de nuestro proyecto, hemos implementado una serie de funciones esenciales para su correcto funcionamiento. Para garantizar que estas funciones cumplen con los requisitos esperados y no introducen errores, se ha decidido realizar pruebas automatizadas sobre ellas. Estas pruebas tienen como objetivo validar que las funciones operan de acuerdo a sus especificaciones y manejan correctamente los casos límites, entradas incorrectas y otros posibles escenarios.

## Decisión
Hemos decidido utilizar Jest para realizar las pruebas, ya que es una herramienta ampliamente utilizada en proyectos JavaScript y TypeScript. Además, cuenta con un ecosistema rico que facilita la configuración y ejecución de pruebas, lo que nos ha permitido escribir y ejecutar pruebas de todas las funcionalidades de manera efectiva y garantizar que el sistema cumple con los requisitos esperados.

## Factores en la Decisión 

* Sencillez
* Ejemplos en la comunidad
* Facilidad de integración con flujo de trabajo de desarrollo

## Opciones Consideradas

* Jest
* Vitest
* Ava

## Ventajas y Desventajas de las opciones

### Jest

#### Ventajas
- Configuración mínima
- Amplia comunidad y documentación
- Soporta TypeScript de forma nativa

#### Desventajas
- Tiempos de ejecución más lentos en comparación con otros

### Vitest

#### Ventajas
- Rápido
- Soporte nativo de TypeScript

#### Desventajas
- Comunidad más pequeña

### Ava

#### Ventajas
- Ejecución en paralelo
- Sintaxis sencilla

#### Desventajas
- Ecosistema pequeño
- Requiere dependencias adicionales para mocks y spies


## Tests realizados

- ### Voting Funcionality
    Prueba la correcta funcionalidad de votar asegurando que los votos se registran correctamente.

- ### Update Charts
    Verifica que los gráficos se actualizar tras cada voto.

- ### Render Charts
    Comprueba que los gráficos se rendericen correctamente al cargar la página y que no haya errores en la visualización inicial

- ### Menu Section Switching
    Comprueba la navegación entre diferentes secciones del menú, asegurando que los datos se actualicen correctamente al cambiar de vista

- ### Icon Circle Click
    Testea las interacciones con los íconos circulares para verificar que activan las funcion de dar la vuelta a la iamgen del participante.

- ### Get Pie Chart Data
     Asegura la correcta generación de datos para los gráficos de tipo *pie*, asegurando que los valores sean precisos y correspondan con los votos registrados

- ### Get Bar Chart Data
     Asegura que los datos generados para los gráficos de barras sean correctos y reflejen fielmente la distribución de votos

- ### Get General Chart Data
    Valida que los datos generales de todos los gráficos sean consistentes y se obtengan correctamente desde la fuente de datos

- ### Fetch Call
    Prueba la correcta ejecución de las llamadas *fetch* para obtener datos desde la API.