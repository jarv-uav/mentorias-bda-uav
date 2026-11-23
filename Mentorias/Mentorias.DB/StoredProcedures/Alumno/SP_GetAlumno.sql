CREATE PROCEDURE [dbo].[SP_GetAlumno]
    @idalumno VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @idalumno IS NOT NULL AND NULLIF(LTRIM(RTRIM(@idalumno)), '') IS NULL
        THROW 50051, N'La matrícula no puede estar vacía.', 1;

    SELECT
        [idalumno],
        [nombre],
        [apellido_paterno],
        [apellido_materno],
        [fecha_nacimiento],
        [telefono],
        [correo_institucional],
        [semestre],
        [foraneo],
        [becado],
        [estado],
        [idcarrera]
    FROM [dbo].[Alumno]
    WHERE @idalumno IS NULL OR [idalumno] = @idalumno
    ORDER BY [idalumno];
END;
GO
