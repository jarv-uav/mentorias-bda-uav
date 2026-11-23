CREATE TABLE [dbo].[EstadoMentoria]
(
    [idestado] INT NOT NULL PRIMARY KEY,
    [estado] VARCHAR(15) NOT NULL UNIQUE,
    [descripcion] VARCHAR(50) NOT NULL
);