CREATE PROCEDURE [dbo].[SP_GetEstadoMentoria]
    @idestado INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @idestado IS NOT NULL AND @idestado < 1
            THROW 50066, N'El identificador del estado de mentoría no es válido.', 1;

        IF @idestado IS NULL
        BEGIN
            SELECT [idestado], [estado], [descripcion]
            FROM [dbo].[EstadoMentoria];
        END
        ELSE
        BEGIN
            SELECT [idestado], [estado], [descripcion]
            FROM [dbo].[EstadoMentoria]
            WHERE [idestado] = @idestado;
        END
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO