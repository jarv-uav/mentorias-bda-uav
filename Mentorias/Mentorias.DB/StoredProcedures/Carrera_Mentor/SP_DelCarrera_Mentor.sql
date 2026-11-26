CREATE PROCEDURE [dbo].[SP_DelCarrera_Mentor]
    @Carreraidcarrera INT,
    @Mentoridmentor NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Carrera_Mentor]
        WHERE Carreraidcarrera = @Carreraidcarrera
          AND Mentoridmentor = @Mentoridmentor
    )
    BEGIN
        RAISERROR('La asignación carrera-mentor no existe.', 16, 1);
        RETURN;
    END

    DELETE FROM [dbo].[Carrera_Mentor]
    WHERE Carreraidcarrera = @Carreraidcarrera
      AND Mentoridmentor = @Mentoridmentor;
END
GO