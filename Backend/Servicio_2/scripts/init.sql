-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DB_API')
BEGIN
    PRINT 'Creando base de datos DB_API';
    CREATE DATABASE DB_API;
END
GO

USE DB_API;
GO

-- Crear la tabla Candidates solo si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Candidates')
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
GO

-- Insertar los datos de los candidatos solo si la tabla existe y no tiene datos
IF NOT EXISTS (SELECT 1 FROM Candidates)
BEGIN
    PRINT 'Insertando datos en la tabla Candidates';
    INSERT INTO Candidates (UserName, UserImage, ImageVoting, UserDescription, Features, Votes)
    VALUES 
    ('Pedro Sánchez', '/participant1.jpg', '/participant1-voting.webp',
    'Pedro Sánchez Pérez-Castejón es un político español, presidente del Gobierno de España desde junio de 2018. Licenciado en Ciencias Económicas y Empresariales por la Universidad Camilo José Cela, es miembro del Partido Socialista Obrero Español (PSOE).',
    '["Presidente del Gobierno de España", "Miembro del PSOE", "Licenciado en Ciencias Económicas", "Enfocado en políticas progresistas"]', 0),

    ('Mariano Rajoy', '/participant2.jpg', '/participant2-voting.webp',
    'Mariano Rajoy Brey es un político español, presidente del Gobierno de España desde diciembre de 2011 hasta junio de 2018. Licenciado en Derecho por la Universidad de Santiago de Compostela, es miembro del Partido Popular (PP).',
    '["Expresidente del Gobierno de España", "Miembro del Partido Popular", "Licenciado en Derecho", "Enfocado en políticas conservadoras", "Figura clave en la crisis económica"]', 0),

    ('Albert Rivera', '/participant3.jpg', '/participant3-voting.webp',
    'Albert Rivera Díaz es un político español, presidente de Ciudadanos desde 2006 hasta 2019. Licenciado en Derecho por la Universidad Ramon Llull, es miembro de Ciudadanos.',
    '["Expresidente de Ciudadanos", "Licenciado en Derecho", "Defensor de la unidad de España", "Moderado en políticas económicas", "Abogado de formación"]', 0),

    ('Pablo Iglesias', '/participant4.jpg', '/participant4-voting.webp',
    'Pablo Iglesias Turrión es un político español, secretario general de Podemos desde 2014. Licenciado en Derecho por la Universidad Complutense de Madrid, es miembro de Podemos.',
    '["Secretario general de Podemos", "Licenciado en Derecho", "Defensor de políticas de izquierda", "Enfocado en justicia social", "Figura destacada en la política española"]', 0);
END
GO

-- Crear la tabla Users solo si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    PRINT 'Creando tabla Users';
    CREATE TABLE Users (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Username NVARCHAR(100) NULL,
        PasswordHash NVARCHAR(500) NULL,
        PasswordSalt NVARCHAR(500) NULL
    );
END
GO