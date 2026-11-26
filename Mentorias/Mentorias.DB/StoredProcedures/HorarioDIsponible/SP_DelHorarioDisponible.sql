CREATE PROCEDURE [dbo].[SP_DelHorarioDisponible]
    @idhorario INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idhorario IS NULL OR @idhorario < 1
            THROW 50241, N'El identificador del horario no es válido.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[HorarioDisponible] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idhorario] = @idhorario
        )
            THROW 50242, N'No existe un horario con ese identificador.', 1;

        DELETE FROM [dbo].[HorarioDisponible]
        WHERE [idhorario] = @idhorario;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO