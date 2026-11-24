CREATE PROCEDURE [dbo].[SP_GetSemaforo]
    @idsemaforo INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @idsemaforo IS NOT NULL AND @idsemaforo < 1
        THROW 50051, N'El identificador de semáforo no es válido.', 1;

    SELECT
        [idsemaforo]
    FROM [dbo].[Semaforo]
    WHERE @idsemaforo IS NULL OR [idsemaforo] = @idsemaforo
    ORDER BY [idsemaforo];
END;
GO