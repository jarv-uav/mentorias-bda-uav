CREATE PROCEDURE [dbo].[SP_GetMentor]
    @idmentor NVARCHAR(10) = NULL,
    @estado BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @idMentorLimpio NVARCHAR(10) = NULLIF(LTRIM(RTRIM(@idmentor)), '');

    SELECT
        [idmentor],
        [nombre],
        [apellido_paterno],
        [apellido_materno],
        [correo_institucional],
        [telefono],
        [estado]
    FROM [dbo].[Mentor]
    WHERE (@idMentorLimpio IS NULL OR [idmentor] = @idMentorLimpio)
      AND (@estado IS NULL OR [estado] = @estado)
    ORDER BY [apellido_paterno], [apellido_materno], [nombre];
END;
GO