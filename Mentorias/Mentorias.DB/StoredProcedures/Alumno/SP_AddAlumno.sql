CREATE PROCEDURE [dbo].[SP_AddAlumno]
    @idalumno VARCHAR(10),
    @nombre VARCHAR(20),
    @apellido_paterno VARCHAR(20),
    @apellido_materno VARCHAR(20),
    @fecha_nacimiento DATE,
    @telefono VARCHAR(15),
    @correo_institucional VARCHAR(30),
    @semestre INT,
    @foraneo BIT,
    @becado BIT,
    @estado BIT,
    @idcarrera INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@idalumno)), '') IS NULL
            THROW 50001, N'La matrícula es obligatoria.', 1;
        IF NULLIF(LTRIM(RTRIM(@nombre)), '') IS NULL
            THROW 50002, N'El nombre es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@apellido_paterno)), '') IS NULL
            THROW 50003, N'El apellido paterno es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@apellido_materno)), '') IS NULL
            THROW 50004, N'El apellido materno es obligatorio.', 1;
        IF @fecha_nacimiento IS NULL
            THROW 50005, N'La fecha de nacimiento es obligatoria.', 1;
        IF @fecha_nacimiento > CONVERT(DATE, GETDATE())
            THROW 50006, N'La fecha de nacimiento no puede ser futura.', 1;
        IF NULLIF(LTRIM(RTRIM(@telefono)), '') IS NULL
            THROW 50007, N'El teléfono es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@correo_institucional)), '') IS NULL
            THROW 50008, N'El correo institucional es obligatorio.', 1;
        IF @semestre IS NULL OR @semestre < 1
            THROW 50009, N'El semestre debe ser mayor que cero.', 1;
        IF @foraneo IS NULL OR @becado IS NULL OR @estado IS NULL
            THROW 50010, N'Los indicadores foraneo, becado y estado son obligatorios.', 1;
        IF @idcarrera IS NULL OR @idcarrera < 1
            THROW 50011, N'La carrera indicada no es válida.', 1;

        BEGIN TRANSACTION;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Alumno] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idalumno] = @idalumno
        )
            THROW 50012, N'Ya existe un alumno con esa matrícula.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Carrera] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idcarrera] = @idcarrera
        )
            THROW 50013, N'La carrera indicada no existe.', 1;

        INSERT INTO [dbo].[Alumno] (
            [idalumno], [nombre], [apellido_paterno], [apellido_materno],
            [fecha_nacimiento], [telefono], [correo_institucional], [semestre],
            [foraneo], [becado], [estado], [idcarrera]
        )
        VALUES (
            @idalumno, @nombre, @apellido_paterno, @apellido_materno,
            @fecha_nacimiento, @telefono, @correo_institucional, @semestre,
            @foraneo, @becado, @estado, @idcarrera
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
