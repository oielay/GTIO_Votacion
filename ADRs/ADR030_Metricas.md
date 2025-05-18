# Métricas

* Estado: aceptada  
* Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana  
* Fecha: 18/05/2025  

Historia técnica: [Issue #97](https://github.com/oielay/GTIO_Votacion/issues/97)

## Contexto y Planteamiento del Problema

Se necesitan medir las métricas de nuestro despliegue en AWS para comprobar que todo vaya como es debido y monitorizar los recursos. Las métricas con fundamentales en un entorno de producción para poder controlar el servicio que se está dando a los clientes y para validar que toda la infraestructura del sistema está funcionando como debería.

## Decisión

Se ha elegido medir las métricas con el servicio Cloudwatch de AWS. De esta forma, se tiene una solución integrada en AWS y que permite una gran flexibilidad al medir las diferentes métricas que genera nuestro ecosistema. Estos datos permitirán implementar un dashboard de observabilidad que conseguirá proporcionarnos información sobre el estado de nuestra infraestructura.

## Tipos de métricas medidas

* Usos de CPU y memoria RAM
* Logs de servicios
* Peticiones de los clientes
