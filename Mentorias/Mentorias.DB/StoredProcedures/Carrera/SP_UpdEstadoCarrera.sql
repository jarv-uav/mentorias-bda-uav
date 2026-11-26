CREATE PROCEDURE [dbo].[SP_UpdEstadoCarrera]
    @idcarrera INT,
    @estado BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idcarrera IS NULL OR @idcarrera < 1
            THROW 50161, N'El identificador de la carrera no es válido.', 1;
        IF @estado IS NULL
            THROW 50162, N'El estado es obligatorio.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Carrera] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idcarrera] = @idcarrera
        )
            THROW 50163, N'No existe una carrera con ese identificador.', 1;

        UPDATE [dbo].[Carrera]
        SET [estado] = @estado
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