#!/bin/bash

# Crear un servicio de api en Kong
curl -i -X POST http://kong:8001/services/ --data "name=api_candidatos" --data "url=http://api_candidatos:8080"

# Crear una ruta para el servicio
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerTodosCandidatos" --data "strip_path=false" --data "name=obtener_todos_candidatos"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerCandidatoPorId" --data "strip_path=false" --data "name=obtener_candidato_por_id"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerDatosPorNombreYApellido" --data "strip_path=false" --data "name=obtener_datos_por_nombre_y_apellido"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerVotosCadidato" --data "strip_path=false" --data "name=obtener_votos_candidato"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/InsertarNuevoCandidato" --data "strip_path=false" --data "name=insertar_nuevo_candidato"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ActualizarVotosCandidato" --data "strip_path=false" --data "name=actualizar_votos_candidato"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/EliminarCandidato" --data "strip_path=false" --data "name=eliminar_candidato"

# Crear un servicio de auth en Kong
curl -i -X POST http://kong:8001/services/ --data "name=api_autenticacion" --data "url=http://api_autenticacion:8080"

# Crear una ruta para el servicio
curl -i -X POST http://kong:8001/services/api_autenticacion/routes --data "paths[]=/api/Auth/Register" --data "strip_path=false" --data "name=registrar_usuario"
curl -i -X POST http://kong:8001/services/api_autenticacion/routes --data "paths[]=/api/Auth/Login" --data "strip_path=false" --data "name=login_usuario"

# Configurar plugin rate-limiting
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=rate-limiting" --data "config.minute=100" --data "config.policy=local"

# Configurar plugin Prometheus
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=prometheus" --data "enabled=true" --data "config.per_consumer=true" --data "config.status_code_metrics=true" --data "config.latency_metrics=true" --data "config.bandwidth_metrics=true" --data "config.upstream_health_metrics=true"

# Configurar plugin file-log para almacenar los logs en un archivo (logging)
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=file-log" --data "config.path=/tmp/candidatos.log" --data "config.reopen=true"

curl -i -X POST http://kong:8001/services/api_autenticacion/plugins --data "name=file-log" --data "config.path=/tmp/autenticacion.log" --data "config.reopen=true"

# Configurar plugin JWT con una clave secreta
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=jwt" --data "config.claims_to_verify=exp" --data "config.key_claim_name=aud" --data "config.secret_is_base64=false" --data "config.uri_param_names=jwt" --data "config.run_on_preflight=false"

# Crear un consumidor
curl -i -X POST http://kong:8001/consumers/ --data "username=admin"
curl -i -X POST http://kong:8001/consumers/admin/jwt --data "key=admin" --data "secret=$KONG_ADMIN_JWT_SECRET"

# Agregar consumidor a grupo admin
curl -i -X POST http://kong:8001/consumers/admin/acls --data "group=admin"

# Configurar ACL (autorización) en rutas
curl -i -X POST http://kong:8001/routes/insertar_nuevo_candidato/plugins --data "name=acl" --data "config.allow=admin"
curl -i -X POST http://kong:8001/routes/actualizar_votos_candidato/plugins --data "name=acl" --data "config.allow=admin"
curl -i -X POST http://kong:8001/routes/eliminar_candidato/plugins --data "name=acl" --data "config.allow=admin"

echo "Configuración completada en Kong."