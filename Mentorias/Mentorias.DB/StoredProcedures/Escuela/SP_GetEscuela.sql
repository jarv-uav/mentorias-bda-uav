CREATE PROCEDURE [dbo].[SP_GetEscuela]
    @idescuela INT = NULL,
    @estado BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT idescuela, nombre, estado
    FROM [dbo].[Escuela]
    WHERE (@idescuela IS NULL OR idescuela = @idescuela)
      AND (@estado IS NULL OR estado = @estado);
END
GO