CREATE PROCEDURE [dbo].[SP_GetHorarioDisponible]
    @idhorario INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @idhorario IS NOT NULL AND @idhorario < 1
        THROW 50251, N'El identificador del horario no es válido.', 1;

    SELECT
        [idhorario],
        [dia_semana],
        [hora_inicio],
        [hora_fin],
        [fecha],
        [periodo],
        [estado],
        [idmentor]
    FROM [dbo].[HorarioDisponible]
    WHERE @idhorario IS NULL OR [idhorario] = @idhorario
    ORDER BY [idhorario];
END;
GO