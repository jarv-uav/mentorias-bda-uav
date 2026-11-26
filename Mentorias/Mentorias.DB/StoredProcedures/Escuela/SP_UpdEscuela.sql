CREATE PROCEDURE [dbo].[SP_UpdEscuela]
    @idescuela INT,
    @nombre VARCHAR(50),
    @estado BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Escuela] WHERE idescuela = @idescuela)
    BEGIN
        RAISERROR('La escuela especificada no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM [dbo].[Escuela] WHERE nombre = @nombre AND idescuela <> @idescuela)
    BEGIN
        RAISERROR('Ya existe otra escuela con ese nombre.', 16, 1);
        RETURN;
    END

    UPDATE [dbo].[Escuela]
    SET nombre = @nombre,
        estado = @estado
    WHERE idescuela = @idescuela;
END
GO