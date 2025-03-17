-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DB_AUTH')
BEGIN
    PRINT 'Creando base de datos DB_AUTH';
    CREATE DATABASE DB_AUTH;
END
GO

USE DB_AUTH;
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