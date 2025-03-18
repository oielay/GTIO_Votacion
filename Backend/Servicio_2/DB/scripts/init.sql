-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DB_AUTH')
BEGIN
    PRINT 'Creando base de datos DB_AUTH';
    CREATE DATABASE DB_AUTH;
END
GO

USE DB_AUTH;
GO

-- Crear la tabla UserTypes si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'UserTypes')
BEGIN
    PRINT 'Creando tabla UserTypes';
    CREATE TABLE UserTypes (
        Id INT PRIMARY KEY,
        TypeName NVARCHAR(50) NOT NULL
    );
    -- Insertar valores (0 = Admin, 1 = Usuario)
    INSERT INTO UserTypes (Id, TypeName) VALUES (0, 'Admin'), (1, 'Usuario');
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
        PasswordSalt NVARCHAR(500) NULL,
        UserTypeId INT NOT NULL DEFAULT 1
    );

    ALTER TABLE Users ADD CONSTRAINT FK_Users_UserTypes
        FOREIGN KEY (UserTypeId) REFERENCES UserTypes(Id);

    INSERT INTO Users (Username, PasswordHash, PasswordSalt, UserTypeId) 
        VALUES ('admin', 'O3DkC1tfsKJiZ0YIg1OQVlRZ1loMzEPXZVHtppaF1/S+Tldl5hw4xvBG4tc87sKmQTx0xnBXDV3g2rgF/A7rYg==', 'Upahe29WGr5KuuMIwvKu2uAgVlafd/TuXNoS5mirAEUGRe4k4PZbb5TCdtWmQffkalj1BnxV2KuinH8WKGJpUWzWdGUbwD6NZNrvZm00XC+qnurvj2bnVknjBkS9x08zgSX8r3KDe8LtS505gXWjbRRAUmmMz3oYy0J+8wwwkug=', 0);
END
GO