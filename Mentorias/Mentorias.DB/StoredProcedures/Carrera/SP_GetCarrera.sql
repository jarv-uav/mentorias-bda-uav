CREATE PROCEDURE [dbo].[SP_GetCarrera]
    @idcarrera INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @idcarrera IS NOT NULL AND @idcarrera < 1
        THROW 50151, N'El identificador de la carrera no es válido.', 1;

    SELECT
        [idcarrera],
        [nombre],
        [estado],
        [idescuela]
    FROM [dbo].[Carrera]
    WHERE @idcarrera IS NULL OR [idcarrera] = @idcarrera
    ORDER BY [idcarrera];
END;
GO
