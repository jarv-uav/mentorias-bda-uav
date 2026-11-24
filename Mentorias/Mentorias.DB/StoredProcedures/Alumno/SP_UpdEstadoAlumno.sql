CREATE PROCEDURE [dbo].[SP_UpdEstadoAlumno]
    @idalumno VARCHAR(10),
    @estado BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@idalumno)), '') IS NULL
            THROW 50061, N'La matrícula es obligatoria.', 1;
        IF @estado IS NULL
            THROW 50062, N'El estado es obligatorio.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Alumno] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idalumno] = @idalumno
        )
            THROW 50063, N'No existe un alumno con esa matrícula.', 1;

        UPDATE [dbo].[Alumno]
        SET [estado] = @estado
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
