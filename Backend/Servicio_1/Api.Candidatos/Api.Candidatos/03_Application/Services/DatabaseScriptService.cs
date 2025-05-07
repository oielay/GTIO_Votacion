using Microsoft.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Api.Candidatos._03_Application.Services
{
    public class DatabaseScriptService : IDatabaseScriptService
    {
        private readonly IConfiguration _configuration;
        private readonly IWebHostEnvironment _env;

        public DatabaseScriptService(IConfiguration configuration, IWebHostEnvironment env)
        {
            _configuration = configuration;
            _env = env;
        }

        public async Task EjecutarScriptAsync(string scriptFileName)
        {
            //string path = Path.Combine(_env.ContentRootPath, "Script", scriptFileName);
            //if (!File.Exists(path))
            //    throw new FileNotFoundException($"El archivo SQL no existe: {path}");

            string script = "-- Crear la base de datos si no existe\r\nIF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DB_API')\r\nBEGIN\r\n    PRINT 'Creando base de datos DB_API';\r\n    CREATE DATABASE DB_API;\r\nEND\r\nGO\r\n\r\nUSE DB_API;\r\nGO\r\n\r\n-- Crear la tabla Candidates solo si no existe\r\nIF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Candidates')\r\nBEGIN\r\n    PRINT 'Creando tabla Candidates';\r\n    CREATE TABLE Candidates (\r\n        Id INT IDENTITY(1,1) PRIMARY KEY,\r\n        UserName NVARCHAR(255) NOT NULL,\r\n        UserImage NVARCHAR(255),\r\n        ImageVoting NVARCHAR(255),\r\n        UserDescription NVARCHAR(MAX),\r\n        Features NVARCHAR(MAX), -- Almacena las características en formato JSON\r\n        Votes INT DEFAULT 0\r\n    );\r\nEND\r\nGO\r\n\r\n-- Insertar los datos de los candidatos solo si la tabla existe y no tiene datos\r\nIF NOT EXISTS (SELECT 1 FROM Candidates)\r\nBEGIN\r\n    PRINT 'Insertando datos en la tabla Candidates';\r\n    INSERT INTO Candidates (UserName, UserImage, ImageVoting, UserDescription, Features, Votes)\r\n    VALUES \r\n    ('Pedro Sánchez', '/participant1.jpg', '/participant1-voting.webp',\r\n    'Pedro Sánchez Pérez-Castejón es un político español, presidente del Gobierno de España desde junio de 2018. Licenciado en Ciencias Económicas y Empresariales por la Universidad Camilo José Cela, es miembro del Partido Socialista Obrero Español (PSOE).',\r\n    'Presidente del Gobierno de España,Miembro del PSOE,Licenciado en Ciencias Económicas,Enfocado en políticas progresistas', 0),\r\n\r\n    ('Mariano Rajoy', '/participant2.jpg', '/participant2-voting.webp',\r\n    'Mariano Rajoy Brey es un político español, presidente del Gobierno de España desde diciembre de 2011 hasta junio de 2018. Licenciado en Derecho por la Universidad de Santiago de Compostela, es miembro del Partido Popular (PP).',\r\n    'Expresidente del Gobierno de España,Miembro del Partido Popular,Licenciado en Derecho,Enfocado en políticas conservadoras,Figura clave en la crisis económica', 0),\r\n\r\n    ('Albert Rivera', '/participant3.jpg', '/participant3-voting.webp',\r\n    'Albert Rivera Díaz es un político español, presidente de Ciudadanos desde 2006 hasta 2019. Licenciado en Derecho por la Universidad Ramon Llull, es miembro de Ciudadanos.',\r\n    'Expresidente de Ciudadanos,Licenciado en Derecho,Defensor de la unidad de España,Moderado en políticas económicas,Abogado de formación', 0),\r\n\r\n    ('Pablo Iglesias', '/participant4.jpg', '/participant4-voting.webp',\r\n    'Pablo Iglesias Turrión es un político español, secretario general de Podemos desde 2014. Licenciado en Derecho por la Universidad Complutense de Madrid, es miembro de Podemos.',\r\n    'Secretario general de Podemos,Licenciado en Derecho,Defensor de políticas de izquierda,Enfocado en justicia social', 0);\r\nEND\r\nGO";

            // Divide el script por líneas que contengan solo "GO"
            var batches = Regex.Split(script, @"^\s*GO\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase);

            string connectionString = _configuration.GetConnectionString("MasterConnection");

            using SqlConnection connection = new SqlConnection(connectionString);
            await connection.OpenAsync();

            foreach (var batch in batches)
            {
                if (string.IsNullOrWhiteSpace(batch)) continue;

                using SqlCommand command = new SqlCommand(batch, connection);
                await command.ExecuteNonQueryAsync();
            }
        }
    }

}