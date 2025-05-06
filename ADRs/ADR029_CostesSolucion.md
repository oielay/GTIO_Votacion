# Costes de la solución

* Estado: aceptada  
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana  
* Fecha: 01/05/2025  

Historia técnica: [Issue #77](https://github.com/oielay/GTIO_Votacion/issues/77) [Subissue #82](https://github.com/oielay/GTIO_Votacion/issues/82)  

## Contexto y Planteamiento del Problema

El despliegue de nuestra arquitectura basada en microservicios en AWS requiere el uso de múltiples servicios gestionados (ECS, EC2, RDS, ELB, etc.). Para asegurar la sostenibilidad del proyecto, especialmente en un entorno académico o con recursos limitados, es necesario analizar y optimizar el coste de cada componente utilizado en la solución.

## Decisión

Se han seleccionado servicios que permiten una buena relación entre control, escalabilidad y precio. Las principales decisiones de coste han sido:

- **Uso de instancias EC2 pequeñas (t2.micro)**: 4 instancias (2 para servicios y 2 en el Auto Scaling Group), en lugar de Fargate, ya que permiten más control y menor coste para cargas de trabajo constantes y predecibles.
- **Separación de bases de datos en RDS**: 1 instancia (db.t2.micro) con 30GB de almacenamiento gp2 de bajo coste.
- **Uso de ECR para imágenes Docker**: 2 repositorios, con eliminación automática de imágenes antiguas para evitar costes por almacenamiento innecesario.
- **Uso de S3 para almacenamiento de archivos estáticos y backups**: 2 buckets, configurados con políticas de ciclo de vida para mover datos antiguos a almacenamiento más económico.
- **Uso de Secrets Manager para la gestión de credenciales y secretos sensibles**, limitando la cantidad de secretos activos para optimizar costes.
- **CloudWatch Logs y métricas** configurados con retención mínima para evitar costes altos de almacenamiento.

## Consecuencias

- Se logra un **coste inicial bajo**, apto para entorno de pruebas o demostraciones.
- Es una arquitectura **escalable**, que podría adaptarse fácilmente a producción ajustando el Auto Scaling Group o el tamaño de las instancias.
- Es necesario **monitorear regularmente** el uso de recursos para evitar gastos innecesarios (p. ej., logs de CloudWatch, imágenes en ECR, objetos en S3 o uso de Secrets Manager).

## Estimación de Costes Mensuales

| Servicio        | Cantidad | Tipo                   | Coste estimado         |
|----------------|----------|-----------------------|-----------------------|
| EC2             | 4        | t2.micro               | ~28 €/mes             |
| RDS             | 1        | db.t2.micro + 30GB     | ~25 €/mes             |
| ECR             | 2        | 1 GB cada uno          | ~0.60 €/mes           |
| ELB             | 1        | ALB                    | ~16 €/mes             |
| S3              | 2        | 10 GB cada uno + peticiones | ~0.60 €/mes    |
| Secrets Manager | 2        | 2 secretos             | ~0.80 €/mes           |
| CloudWatch      | —        | Logs + métricas básicas| ~2 €/mes              |
| **Total estimado** | —      | —                     | **~70-75 €/mes**      |

> Nota: Precios estimados con tarifas estándar en la región US East (N. Virginia). Para uso intensivo o producción, los costes podrían incrementarse.

## Enlaces

* Precios consultados en [AWS Pricing Calculator](https://calculator.aws/)

## Observaciones

- Si la carga aumenta, se debe considerar ampliar el Auto Scaling Group o migrar a instancias más grandes o Fargate.
- Es recomendable habilitar AWS Budgets para controlar los gastos automáticamente.(Falta de permisos)
