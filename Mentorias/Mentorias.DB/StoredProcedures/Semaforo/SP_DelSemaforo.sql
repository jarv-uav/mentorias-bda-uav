CREATE PROCEDURE [dbo].[SP_DelSemaforo]
    @idsemaforo INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idsemaforo IS NULL OR @idsemaforo < 1
            THROW 50041, N'El identificador de semáforo no es válido.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idsemaforo] = @idsemaforo
        )
            THROW 50042, N'No existe un registro de semáforo con ese identificador.', 1;

        DELETE FROM [dbo].[Semaforo]
        WHERE [idsemaforo] = @idsemaforo;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO