CREATE PROCEDURE [dbo].[SP_AddCarrera_Mentor]
    @Carreraidcarrera INT,
    @Mentoridmentor NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Carrera] WHERE idcarrera = @Carreraidcarrera AND estado = 1)
    BEGIN
        RAISERROR('La carrera no existe o está inactiva.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Mentor] WHERE idmentor = @Mentoridmentor AND estado = 1)
    BEGIN
        RAISERROR('El mentor no existe o está inactivo.', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM [dbo].[Carrera_Mentor]
        WHERE Carreraidcarrera = @Carreraidcarrera
          AND Mentoridmentor = @Mentoridmentor
    )
    BEGIN
        RAISERROR('Este mentor ya está asignado a esa carrera.', 16, 1);
        RETURN;
    END

    INSERT INTO [dbo].[Carrera_Mentor] (Carreraidcarrera, Mentoridmentor)
    VALUES (@Carreraidcarrera, @Mentoridmentor);
END
GO