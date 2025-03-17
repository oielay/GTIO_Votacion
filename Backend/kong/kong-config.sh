#!/bin/bash

# Crear un servicio de api en Kong
curl -i -X POST http://kong:8001/services/ --data "name=api_candidatos" --data "url=http://api_candidatos:8080"

# Crear una ruta para el servicio
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerTodosCandidatos" --data "strip_path=false"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerCandidatoPorId" --data "strip_path=false"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerDatosPorNombreYApellido" --data "strip_path=false"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/InsertarNuevoCandidato" --data "strip_path=false"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ActualizarDatosCandidato/" --data "strip_path=false"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/EliminarCandidato" --data "strip_path=false"
curl -i -X POST http://kong:8001/services/api_candidatos/routes --data "paths[]=/api/Candidates/ObtenerVotosCadidato" --data "strip_path=false"

# Crear un servicio de auth en Kong
curl -i -X POST http://kong:8001/services/ --data "name=api_autenticacion" --data "url=http://api_autenticacion:8080"

# # Crear una ruta para el servicio
curl -i -X POST http://kong:8001/services/api_autenticacion/routes --data "paths[]=/api/Auth/Register" --data "strip_path=false"
curl -i -X POST http://kong:8001/services/api_autenticacion/routes --data "paths[]=/api/Auth/Login" --data "strip_path=false"

# Configurar plugin rate-limiting
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=rate-limiting" --data "config.minute=100" --data "config.policy=local"

# Configurar plugin Prometheus
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=prometheus" --data "enabled=true" --data "config.per_consumer=true" --data "config.status_code_metrics=true" --data "config.latency_metrics=true" --data "config.bandwidth_metrics=true" --data "config.upstream_health_metrics=true"

# Configurar plugin file-log para almacenar los logs en un archivo
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=file-log" --data "config.path=/tmp/candidatos.log" --data "config.reopen=true"

curl -i -X POST http://kong:8001/services/api_autenticacion/plugins --data "name=file-log" --data "config.path=/tmp/autenticacion.log" --data "config.reopen=true"

# Crear un consumidor
curl -i -X POST http://kong:8001/consumers/ --data "username=usuario"

# Configurar plugin JWT con una clave secreta
curl -i -X POST http://kong:8001/services/api_candidatos/plugins --data "name=jwt" --data "config.claims_to_verify=exp" --data "config.key_claim_name=aud" --data "config.secret_is_base64=false" --data "config.uri_param_names=jwt" --data "config.run_on_preflight=false"

echo "Configuración completada en Kong."