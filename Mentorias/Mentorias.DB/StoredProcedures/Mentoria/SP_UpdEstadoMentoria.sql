CREATE PROCEDURE [dbo].[SP_UpdEstadoMentoria]
    @idmentoria INT,
    @idestado INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idmentoria IS NULL OR @idmentoria < 1
            THROW 50061, N'El identificador de mentoría no es válido.', 1;
        IF @idestado IS NULL OR @idestado < 1
            THROW 50062, N'El estado de mentoría indicado no es válido.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentoria] = @idmentoria
        )
            THROW 50063, N'No existe una mentoría con ese identificador.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idestado] = @idestado
        )
            THROW 50064, N'El estado de mentoría indicado no existe.', 1;

        UPDATE [dbo].[Mentoria]
        SET [idestado] = @idestado
        WHERE [idmentoria] = @idmentoria;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO