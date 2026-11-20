CREATE PROCEDURE [dbo].[sp_InsertarEstadoMentoria]
    @idestado INT,
    @estado VARCHAR(15),
    @descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[EstadoMentoria] ([idestado], [estado], [descripcion])
    VALUES (@idestado, @estado, @descripcion);
END;
GO

CREATE PROCEDURE [dbo].[sp_ObtenerEstadosMentoria]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [idestado], [estado], [descripcion]
    FROM [dbo].[EstadoMentoria];
END;
GO

CREATE PROCEDURE [dbo].[sp_ActualizarEstadoMentoria]
    @idestado INT,
    @estado VARCHAR(15),
    @descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[EstadoMentoria]
    SET [estado] = @estado,
        [descripcion] = @descripcion
    WHERE [idestado] = @idestado;
END;
GO

CREATE PROCEDURE [dbo].[sp_EliminarEstadoMentoria]
    @idestado INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[EstadoMentoria]
    WHERE [idestado] = @idestado;
END;
GO