CREATE PROCEDURE [dbo].[SP_DelEscuela]
    @idescuela INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Escuela] WHERE idescuela = @idescuela)
    BEGIN
        RAISERROR('La escuela especificada no existe.', 16, 1);
        RETURN;
    END

    DELETE FROM [dbo].[Escuela]
    WHERE idescuela = @idescuela;
END
GO