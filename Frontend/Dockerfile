# Usar una imagen de Node.js ligera
FROM node:20-alpine

# Instalar curl
RUN apk add --no-cache curl

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar package.json y package-lock.json (si existe) antes de instalar dependencias
COPY package.json package-lock.json* ./ 

# Instalar las dependencias
RUN npm install

# Copiar el resto del código fuente
COPY . .

# Exponer el puerto en el que corre el frontend
EXPOSE 1234

# Comando por defecto para ejecutar la aplicación en modo desarrollo
CMD ["npm", "run", "dev", "--", "--host", "--port", "1234"]