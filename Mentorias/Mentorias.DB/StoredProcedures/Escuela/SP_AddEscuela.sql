CREATE PROCEDURE [dbo].[SP_AddEscuela]
    @nombre VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM [dbo].[Escuela] WHERE nombre = @nombre)
    BEGIN
        RAISERROR('Ya existe una escuela con ese nombre.', 16, 1);
        RETURN;
    END

    INSERT INTO [dbo].[Escuela] (nombre, estado)
    VALUES (@nombre, 1);

    SELECT SCOPE_IDENTITY() AS idescuela;
END
GO