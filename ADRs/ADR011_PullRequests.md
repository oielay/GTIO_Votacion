# Pull Requests

* Estado: aceptada
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana
* Fecha: 12/02/2025

Historia técnica: [Issue #5](https://github.com/oielay/GTIO_Votacion/issues/5) [Subissue #21](https://github.com/oielay/GTIO_Votacion/issues/21)

## Contexto
Para mantener un desarrollo colaborativo eficiente y garantizar la calidad del código, es necesario definir un flujo estructurado para la creación y revisión de Pull Requests (PRs). Esto permitirá detectar errores, mejorar la mantenibilidad del código y asegurar la alineación con las mejores prácticas del equipo.

## Opciones Consideradas
- Fusionar cambios directamente sin revisión
    - Más rápido, pero aumenta el riesgo de introducir errores y código inconsistente.

- Revisión posterior a la fusión
    - Permite rapidez en el desarrollo, pero no previene errores antes de llegar a la rama principal.

- Uso de Pull Requests con revisión obligatoria
    - Asegura calidad y revisión de código antes de la fusión.
    - Requiere disciplina del equipo para mantener un flujo ágil.

## Decisión
Se establece un proceso estándar para la creación y revisión de Pull Requests, asegurando que cada cambio sea revisado y aprobado antes de fusionarse en la rama principal.

## Reglas para Pull Requests
1. Cada PR debe estar asociado a una issue.

2. Uso de la estructura de los commit en el título: `<tipo> (<área>): <descripción breve> #<número_issue_padre>`.

3. Opcional incluir una descripción detallada explicando los cambios, el motivo y cualquier contexto adicional.

4. Dividir los cambios en commits bien definidos y asignados a sub-issues, siguiendo la convención de mensajes de commit.

5. Ejecutar pruebas y validaciones antes de solicitar revisión.

6. Revisión por al menos un miembro del equipo antes de su aprobación.

## Ejemplo de titulo PR

`docs(rfi1): definida arquitectura del programa #123`

## Justificación
- Garantiza que cada cambio pase por una revisión antes de fusionarse.
- Facilita la colaboración y retroalimentación entre los miembros del equipo.
- Mejora la trazabilidad al vincular los PRs con las issues.
- Reduce la probabilidad de introducir errores en la rama principal.
- Mantiene un historial de cambios más limpio y organizado.

## Consecuencias

- Todos los desarrolladores deben seguir este proceso para sus contribuciones.
- Puede agregar tiempo al proceso de integración, pero mejora la calidad del código.
