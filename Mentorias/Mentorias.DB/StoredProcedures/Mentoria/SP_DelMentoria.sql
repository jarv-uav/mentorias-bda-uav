CREATE PROCEDURE [dbo].[SP_DelMentoria]
    @idmentoria INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idmentoria IS NULL OR @idmentoria < 1
            THROW 50041, N'El identificador de mentoría no es válido.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentoria] = @idmentoria
        )
            THROW 50042, N'No existe una mentoría con ese identificador.', 1;

        DELETE FROM [dbo].[Mentoria]
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