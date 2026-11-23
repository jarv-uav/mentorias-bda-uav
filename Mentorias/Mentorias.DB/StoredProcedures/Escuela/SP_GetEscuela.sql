CREATE PROCEDURE [dbo].[SP_GetEscuela]
    @idescuela INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT idescuela, nombre, estado
    FROM [dbo].[Escuela]
    WHERE (@idescuela IS NULL OR idescuela = @idescuela)
      AND estado = 1;
END
GO