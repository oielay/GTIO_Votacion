# Métricas

- Estado: aceptada
- Responsables: Javier Pernaut, Oier Alduncin, Alexander Sarango, Urki Aristu, Oier Layana
- Fecha: 18/05/2025

Historia técnica: [Issue #97](https://github.com/oielay/GTIO_Votacion/issues/97)

## Contexto y Planteamiento del Problema

Se necesitan medir las métricas de nuestro despliegue en AWS para comprobar que todo vaya como es debido y monitorizar los recursos. Las métricas con fundamentales en un entorno de producción para poder controlar el servicio que se está dando a los clientes y para validar que toda la infraestructura del sistema está funcionando como debería.

## Decisión

Se ha elegido medir las métricas con el servicio **CloudWatch** de AWS. De esta forma, se dispone de una solución **nativa, totalmente integrada** en el ecosistema de AWS, lo que permite una **gran flexibilidad y escalabilidad** en la recogida, análisis y visualización de datos operativos. Estos datos se utilizan para implementar **dashboards de observabilidad**, que proporciona información crítica y en tiempo real sobre el estado y rendimiento de toda la infraestructura desplegada en la nube.

## Tipos de métricas medidas

Las métricas recopiladas cubren aspectos clave del rendimiento y disponibilidad de cada componente del sistema. A continuación, se detallan los servicios monitorizados y las métricas observadas (no están todas listadas dado que mostramos todas las métricas de cada servicio en el dashboard):

### 1. **Amazon API Gateway**

- Número de solicitudes (`Count`)
- Latencia media de respuesta (`Latency`)
- Errores del cliente (4xx) y del servidor (5xx)
- Tasa de aciertos en caché (si aplica)
- Integración con CloudWatch Logs para trazar peticiones y errores

### 2. **Amazon ECS (Elastic Container Service)**

- Uso de **CPU** y **memoria RAM** por servicio y contenedor
- Estado de las tareas (en ejecución, detenidas, fallidas)
- Reintentos de tareas
- Métricas de autoscaling (si se usa)
- Logs de contenedores redirigidos a CloudWatch Logs

### 3. **Amazon EC2**

- Uso de **CPU**, **RAM**, **E/S de disco**, y **red (NetworkIn/Out)**
- Estado de salud de las instancias
- Logs del sistema si se integran con CloudWatch Agent
- Alertas de disponibilidad y escalabilidad (si se usan auto scaling groups)

### 4. **Amazon RDS (Relational Database Service)**

- Uso de CPU y memoria del motor de base de datos
- Conexiones activas
- Latencia de consultas
- Espacio de almacenamiento disponible
- Métricas de IOPS (lecturas/escrituras)
- Eventos de backup, reinicio o errores del motor

### 5. **Elastic Load Balancer (ALB/NLB)**

- Número total de peticiones (`RequestCount`)
- Errores 4xx y 5xx
- Latencia media por petición (`TargetResponseTime`)
- Número de targets saludables / no saludables
- Tasa de conexiones establecidas
- Métricas diferenciadas por listener y por target group

### 6. **CloudWatch Logs**

- Agregación de logs desde ECS, EC2 y API Gateway
- Búsqueda y análisis en tiempo real de eventos de error o advertencia
- Filtros de métricas personalizados para generar alarmas
- Integración con CloudWatch Insights para consultas avanzadas
- Visualización de trazas, errores y tiempos de respuesta de aplicaciones
