# Observabilidad

* Estado: aceptada  
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana  
* Fecha: 20/05/2025  

Historia técnica: [Issue #98](https://github.com/oielay/GTIO_Votacion/issues/98)

## Contexto y Planteamiento del Problema

Se necesitan definir cómo y con qué herramientas se van a mostrar las métricas y logs que generan los servicios y diferentes recursos de AWS. Este tema es muy importante para monitorizar todos los recursos que tenemos en la nube, así como para comprobar que los servicios están funcionando de forma correcta y para la trazabilidad de los flujos de ejecución de los usuarios. Si no se implementa la observabilidad no se tiene información sobre el estado de los servicios.

## Decisión

Se ha elegido hacer un dashboard en Grafana para la observabilidad de la base de datos y otro dashboard en Cloudwatch para mostrar las métricas y logs restantes. Se ha intentado hacer un dashboard completo en Grafana con todas las métricas y logs de Cloudwatch pero el rol de nuestras cuentas LabRole no tiene permisos para leer de Cloudwatch directamente, por lo que Grafana no puede conectarse a Cloudwatch para leer los datos. Es por esta razón por la que se ha elegido implementar dos dashboards diferentes.
