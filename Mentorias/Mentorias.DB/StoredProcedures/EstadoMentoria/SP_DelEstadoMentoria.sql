CREATE PROCEDURE [dbo].[SP_DelEstadoMentoria]
    @idestado INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idestado IS NULL OR @idestado < 1
            THROW 50072, N'El identificador del estado de mentoría no es válido.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idestado] = @idestado
        )
            THROW 50073, N'No existe un estado de mentoría con ese identificador.', 1;

        DELETE FROM [dbo].[EstadoMentoria]
        WHERE [idestado] = @idestado;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO