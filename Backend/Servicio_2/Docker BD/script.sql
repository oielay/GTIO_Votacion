-- Crear base de datos
CREATE DATABASE DB_API;
GO

-- Usar la base de datos
USE DB_API;
GO

-- Crear la tabla Candidates
CREATE TABLE Candidates (
   Id INT IDENTITY(1,1) PRIMARY KEY,
   UserName NVARCHAR(100),
   LastName NVARCHAR(100),
   Country NVARCHAR(100),
   Votes INT DEFAULT 0,
   Photo NVARCHAR(255),
   UserDescription NVARCHAR(MAX)
);
GO

-- Insertar registros de ejemplo
INSERT INTO Candidates (UserName, LastName, Country, Votes, Photo, UserDescription)
VALUES
('Pedro', 'Sanchez', 'España', 0, 'foto_pedro.jpg', 'Pedro Sánchez es un político español, líder del Partido Socialista Obrero Español (PSOE) y presidente del Gobierno de España.'),
('Santiago', 'Abascal', 'España', 0, 'foto_abascal.jpg', 'Santiago Abascal es un político español, fundador y presidente de VOX, un partido político de extrema derecha en España.'),
('Pablo', 'Iglesias', 'España', 0, 'foto_iglesias.jpg', 'Pablo Iglesias es un político y académico español, cofundador de Podemos, un partido político de izquierda en España.');
GO
