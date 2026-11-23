CREATE PROCEDURE [dbo].[SP_GetMentoria]
    @idmentoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @idmentoria IS NOT NULL AND @idmentoria < 1
        THROW 50051, N'El identificador de mentoría no es válido.', 1;

    SELECT
        [idmentoria],
        [fecha_propuesta],
        [hora_propuesta],
        [motivo],
        [presencial],
        [observaciones],
        [idestado],
        [idsemaforo],
        [idalumno],
        [idmentor]
    FROM [dbo].[Mentoria]
    WHERE @idmentoria IS NULL OR [idmentoria] = @idmentoria
    ORDER BY [idmentoria];
END;
GO