CREATE PROCEDURE [dbo].[SP_DelMentor]
    @idmentor NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@idmentor)), '') IS NULL
            THROW 50201, N'El ID del mentor es obligatorio.', 1;

        DECLARE @idMentorLimpio NVARCHAR(10) = LTRIM(RTRIM(@idmentor));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentor] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idMentorLimpio
        )
            THROW 50210, N'No existe un mentor con ese ID.', 1;

        DELETE FROM [dbo].[Mentor]
        WHERE [idmentor] = @idMentorLimpio;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO