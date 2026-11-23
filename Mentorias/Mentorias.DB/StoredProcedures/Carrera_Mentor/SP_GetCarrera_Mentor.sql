CREATE PROCEDURE [dbo].[SP_GetCarrera_Mentor]
    @Carreraidcarrera INT = NULL,
    @Mentoridmentor NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        cm.Carreraidcarrera,
        c.nombre AS nombre_carrera,
        cm.Mentoridmentor,
        CONCAT(m.nombre, ' ', m.apellido_paterno, ' ', m.apellido_materno) AS nombre_mentor
    FROM [dbo].[Carrera_Mentor] cm
    INNER JOIN [dbo].[Carrera] c ON cm.Carreraidcarrera = c.idcarrera
    INNER JOIN [dbo].[Mentor] m ON cm.Mentoridmentor = m.idmentor
    WHERE (@Carreraidcarrera IS NULL OR cm.Carreraidcarrera = @Carreraidcarrera)
      AND (@Mentoridmentor IS NULL OR cm.Mentoridmentor = @Mentoridmentor);
END
GO