# Usa una imagen base de Python
FROM python:3.8-slim

# Instalar dependencias para pyodbc
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    unixodbc-dev \
    && pip install --upgrade pip \
    && pip install pyodbc

# Copiar el script de Python a la imagen
COPY init.py /usr/src/app/db_creation_script.py

# Establecer el directorio de trabajo
WORKDIR /usr/src/app

# Comando para ejecutar el script cuando inicie el contenedor
CMD ["python", "db_creation_script.py"]