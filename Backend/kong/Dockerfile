# Usamos una imagen base ligera de Alpine
FROM alpine:latest

# Instalamos curl y bash (si es necesario)
RUN apk add --no-cache curl bash

# Copiamos el script al contenedor
COPY kong-config.sh /script.sh

# Hacemos que el script sea ejecutable
RUN chmod +x /script.sh

# Comando por defecto: ejecutar el script cuando se inicie el contenedor
CMD ["/script.sh"]