CREATE PROCEDURE [dbo].[SP_DelCoordinacion]
    @idcoordinador NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@idcoordinador)), '') IS NULL
            THROW 50101, N'El ID del coordinador es obligatorio.', 1;

        DECLARE @idCoordLimpio NVARCHAR(10) = LTRIM(RTRIM(@idcoordinador));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Coordinacion] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idcoordinador] = @idCoordLimpio
        )
            THROW 50107, N'No existe un registro en Coordinacion con ese ID.', 1;

        DELETE FROM [dbo].[Coordinacion]
        WHERE [idcoordinador] = @idCoordLimpio;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO