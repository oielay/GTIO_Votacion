# Usar una imagen de Node.js ligera
FROM node:20-alpine

# Instalar dependencias necesarias del sistema (opcional, según tu app)
RUN apk add --no-cache curl

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar package.json y package-lock.json* antes de instalar dependencias
COPY package.json package-lock.json* ./

# Instalar dependencias del proyecto
RUN npm install

# Copiar el resto del código fuente
COPY . .

ARG PUBLIC_API_URL
ENV PUBLIC_API_URL=${PUBLIC_API_URL}
ARG PUBLIC_API_KEY
ENV PUBLIC_API_KEY=${PUBLIC_API_KEY}

# Ejecutar el build del proyecto
RUN npm run build

# Exponer el puerto (Astro por defecto escucha en el 3000)
ENV HOST=0.0.0.0
ENV PORT=3000
EXPOSE 3000

# Instala servidor estático para servir 'dist'
RUN npm install -g serve

# Exponer el puerto en el que corre el frontend
EXPOSE 3000

# Comando por defecto para ejecutar la aplicación en modo desarrollo
CMD ["serve", "dist", "-l", "3000"]

# # Imagen base ligera
# FROM node:20-alpine

# # Instalar dependencias del sistema (si las necesitas)
# RUN apk add --no-cache curl

# # Directorio de trabajo
# WORKDIR /app

# # Copiar archivos de dependencias
# COPY package.json package-lock.json* ./

# # Instalar dependencias
# RUN npm install

# # Copiar el resto del proyecto
# COPY . .

# # Variables de entorno
# ENV HOST=0.0.0.0
# ENV PORT=3000

# # Exponer puerto de desarrollo
# EXPOSE 3000

# # Comando para modo desarrollo
# CMD ["npm", "run", "dev"]