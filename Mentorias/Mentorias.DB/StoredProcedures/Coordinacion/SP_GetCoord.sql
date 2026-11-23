CREATE PROCEDURE [dbo].[SP_GetCoordinacion]
    @idcoordinador NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @idCoordLimpio NVARCHAR(10) = NULLIF(LTRIM(RTRIM(@idcoordinador)), '');

    SELECT
        [idcoordinador],
        [nombre],
        [apellido_paterno],
        [apellido_materno],
        [correo_institucional]
    FROM [dbo].[Coordinacion]
    WHERE (@idCoordLimpio IS NULL OR [idcoordinador] = @idCoordLimpio)
    ORDER BY [apellido_paterno], [apellido_materno], [nombre];
END;
GO