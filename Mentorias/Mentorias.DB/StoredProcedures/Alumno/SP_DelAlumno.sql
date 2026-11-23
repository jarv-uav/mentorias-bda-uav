CREATE PROCEDURE [dbo].[SP_DelAlumno]
    @idalumno VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@idalumno)), '') IS NULL
            THROW 50041, N'La matrícula es obligatoria.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Alumno] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idalumno] = @idalumno
        )
            THROW 50042, N'No existe un alumno con esa matrícula.', 1;

        DELETE FROM [dbo].[Alumno]
        WHERE [idalumno] = @idalumno;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
