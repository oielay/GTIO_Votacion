# Metodología

* Estado: aceptada
* Responsables: Urki Aristu, Oier Layana, Javier Pernaut, Oier Alduncin y Alexander Sarango
* Fecha: 26/02/2025

Historia técnica: [Issue #51](https://github.com/oielay/GTIO_Votacion/issues/51) [Subissue #64](https://github.com/oielay/GTIO_Votacion/issues/64)

## Contexto y Planteamiento del Problema

El objetivo principal de esta metodología es garantizar que el código que se incorpora a la rama main siga las mejores prácticas y esté libre de errores. Esto permitirá mejorar la mantenibilidad del proyecto, reducir la carga de revisión manual y disminuir la probabilidad de introducir errores en el sistema. Para ello, se han definido unas ideas para definir la metodologia utilizada.

## Definición de la Metodología
### Tarea Terminada

Para que una tarea se considere terminada, debe cumplir con los siguientes criterios:

- Ha sido implementada completamente según las especificaciones del *issue* asignado.

- Ha sido revisada mediante el sistema de linting y pruebas automatizadas.

- La documentación correspondiente ha sido actualizada si es necesario.

### Flujo de Movimiento del Código Fuente

1. Un desarrollador toma una *issue* desde el backlog.

2. Si esa *issue* es una *sub-issue* deberia ser implementada en una rama aparte y al completa la *issue* padre mergearla en la rama `desarrollo`. Si es una unica *issue* suelta, podrá trabajar en la rama `desarrollo` directamente.

3. Implementa los cambios asegurándose de seguir las reglas de linting.

4. Si se quiere de mergear la rama `desarrollo` en `main`, se abre un Pull Request (PR).

5. Otro desarrollador revisa el PR y sugiere cambios si es necesario.

6. Si el PR es aprobado, se fusiona en main.

7. Se ejecutan pruebas en CI para verificar que el código es funcional.

### Aprobación de Cambios

- Todo PR debe ser revisado por al menos otro desarrollador antes de ser fusionado.

- Las revisiones quedan documentadas en GitHub, donde se registran los comentarios y sugerencias de los revisores.


