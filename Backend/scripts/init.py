import json
import pyodbc
import time
import os
import logging

# Configuración básica del logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Puedes cambiar el nivel a DEBUG si necesitas más detalles

# Handler para enviar logs a CloudWatch
cloudwatch_handler = logging.StreamHandler()  # Usamos StreamHandler para capturar la salida estándar
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
cloudwatch_handler.setFormatter(formatter)
logger.addHandler(cloudwatch_handler)

def lambda_handler(event, context):
    # Parámetros de conexión (variables de entorno)
    server = os.environ['DB_SERVER']
    database = "master"
    username = os.environ['DB_USER']
    password = os.environ['DB_PASSWORD']

    logger.info("Inicio del proceso de conexión a la base de datos.")
    
    while True:
        try:
            # Intentar conectar a la base de datos
            conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};'
                                  f'SERVER={server},1433;'
                                  f'DATABASE={database};'
                                  f'UID={username};'
                                  f'PWD={password}')
            logger.info(f"Conexión exitosa a la base de datos {database}.")
            break  # Si la conexión es exitosa, salimos del ciclo
        except Exception as e:
            logger.warning(f"Esperando a que RDS esté disponible... Error: {str(e)}")
            time.sleep(10)  # Esperamos 10 segundos antes de intentar de nuevo

    # Cadena de conexión
    conn_str = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

    try:
        # Conexión a la base de datos
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()

        # Crear la base de datos si no existe
        cursor.execute("""
        DB_ID('DB_API') IS NULL
        BEGIN
            PRINT 'Creando base de datos DB_API';
            CREATE DATABASE DB_API;
        END
        """)
        cursor.commit()

        logger.info("Base de datos DB_API creada correctamente o ya existe.")

        # Usar la base de datos DB_API
        cursor.execute("USE DB_API")
        cursor.commit()

        # Crear la tabla Candidates solo si no existe
        cursor.execute("""
        IF OBJECT_ID('dbo.Candidates', 'U') IS NULL
        BEGIN
            PRINT 'Creando tabla Candidates';
            CREATE TABLE Candidates (
                Id INT IDENTITY(1,1) PRIMARY KEY,
                UserName NVARCHAR(255) NOT NULL,
                UserImage NVARCHAR(255),
                ImageVoting NVARCHAR(255),
                UserDescription NVARCHAR(MAX),
                Features NVARCHAR(MAX), -- Almacena las características en formato JSON
                Votes INT DEFAULT 0
            );
        END
        """)
        cursor.commit()

        logger.info("Tabla Candidates creada correctamente o ya existe.")

        # Insertar los datos de los candidatos solo si la tabla existe y no tiene datos
        cursor.execute("""
        IF NOT EXISTS (SELECT 1 FROM dbo.Candidates)
        BEGIN
            PRINT 'Insertando datos en la tabla Candidates';
            INSERT INTO Candidates (UserName, UserImage, ImageVoting, UserDescription, Features, Votes)
            VALUES 
            ('Pedro Sánchez', '/participant1.jpg', '/participant1-voting.webp',
            'Pedro Sánchez Pérez-Castejón es un político español, presidente del Gobierno de España desde junio de 2018. Licenciado en Ciencias Económicas y Empresariales por la Universidad Camilo José Cela, es miembro del Partido Socialista Obrero Español (PSOE).',
            'Presidente del Gobierno de España,Miembro del PSOE,Licenciado en Ciencias Económicas,Enfocado en políticas progresistas', 0),

            ('Mariano Rajoy', '/participant2.jpg', '/participant2-voting.webp',
            'Mariano Rajoy Brey es un político español, presidente del Gobierno de España desde diciembre de 2011 hasta junio de 2018. Licenciado en Derecho por la Universidad de Santiago de Compostela, es miembro del Partido Popular (PP).',
            'Expresidente del Gobierno de España,Miembro del Partido Popular,Licenciado en Derecho,Enfocado en políticas conservadoras,Figura clave en la crisis económica', 0),

            ('Albert Rivera', '/participant3.jpg', '/participant3-voting.webp',
            'Albert Rivera Díaz es un político español, presidente de Ciudadanos desde 2006 hasta 2019. Licenciado en Derecho por la Universidad Ramon Llull, es miembro de Ciudadanos.',
            'Expresidente de Ciudadanos,Licenciado en Derecho,Defensor de la unidad de España,Moderado en políticas económicas,Abogado de formación', 0),

            ('Pablo Iglesias', '/participant4.jpg', '/participant4-voting.webp',
            'Pablo Iglesias Turrión es un político español, secretario general de Podemos desde 2014. Licenciado en Derecho por la Universidad Complutense de Madrid, es miembro de Podemos.',
            'Secretario general de Podemos,Licenciado en Derecho,Defensor de políticas de izquierda,Enfocado en justicia social', 0);
        END
        """)
        cursor.commit()

        logger.info("Datos insertados correctamente en la tabla Candidates.")

        return {
            'statusCode': 200,
            'body': json.dumps('Base de datos y tabla Candidates creadas e insertadas correctamente')
        }
    
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error: {str(e)}")
        }
    
    finally:
        cursor.close()
        conn.close()