# Estructura de Commits

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana
* Fecha: 12/02/2025
Historia técnica: [Issue #5](https://github.com/oielay/GTIO_Votacion/issues/5) [Subissue #19](https://github.com/oielay/GTIO_Votacion/issues/19)


## Contexto
Para mantener un historial de cambios claro, comprensible y consistente en el proyecto, es fundamental definir una estructura de commits estandarizada. Esto facilita la revisión de código, la depuración de errores y la colaboración en equipo.

## Opciones Consideradas
1. Commits sin una estructura estándar
    - Los mensajes de commit son escritos libremente por cada desarrollador
    - Ejemplo: Añadida nueva tabla a base de datos #123
2. Uso de convenciones personalizadas
    - Se define una estructura propia dentro del equipo basada en experiencia de los particioantes.
    - Ejemplo: 123 - FUNC - Añadida nueva tabla a la base de datos
3. Convención basada en Conventional Commits
    - Proporciona una estructura clara y ampliamente adoptada en la industria.
    - Ejemplo: feat(bbdd): añadida nueva tabla a la base de datos (#123)

## Decisión
Se establece el uso de una convención de mensajes de commit basada en [Conventional Commits](https://www.conventionalcommits.org/), con la siguiente estructura:

`<tipo>(<área>): <mensaje corto> (#<número_issue>)`

`<Cuerpo opcional>`

En caso de que la issue a realizar sea una sub-issue se pondrá el numero de la sub-issue y se usará el numero del issue padre para el PR a main de la rama en la que se esta realizando dicho commit.

## Tipos de commit
Los commits deben clasificarse en los siguientes tipos:
- `feat`: Agrega una nueva funcionalidad.
- `fix`: Corrige un error.
- `docs`: Cambios en la documentación.
- `style`: Cambios de formato, espacios, comas, sin afectar la lógica del código.
- `refactor`: Cambios en el código que no corrigen errores ni agregan funcionalidades.
- `perf`: Mejoras de rendimiento.
- `test`: Adición o modificación de pruebas.
- `chore`: Tareas de mantenimiento o configuración.

## Ejemplos
1. Agregar una nueva funcionalidad:

    `feat(frontend): crear seccion de participantes (#123)`

2. Corregir un error:

    `fix(backend): corregir guardado de voto en BBDD (#456)`

3. Documentación:

    `docs(rfi1): actualizar ADR009 Estructura de Commits (#789)`

## Justificación
- Estandariza los mensajes de commit, facilitando la lectura y el análisis del historial.
- Mejora la colaboración y comprensión entre los miembros del equipo.
- Asocia cada commit a una issue específica, facilitando el rastreo de cambios.

## Consecuencias
- Todos los miembros del equipo deberán seguir esta convención.