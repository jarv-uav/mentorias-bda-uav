CREATE PROCEDURE [dbo].[SP_DelCarrera]
    @idcarrera INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idcarrera IS NULL OR @idcarrera < 1
            THROW 50141, N'El identificador de la carrera no es válido.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Carrera] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idcarrera] = @idcarrera
        )
            THROW 50142, N'No existe una carrera con ese identificador.', 1;

        DELETE FROM [dbo].[Carrera]
        WHERE [idcarrera] = @idcarrera;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO