CREATE PROCEDURE [dbo].[SP_UpdAlumno]
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
            THROW 50021, N'La matrícula es obligatoria.', 1;
        IF NULLIF(LTRIM(RTRIM(@nombre)), '') IS NULL
            THROW 50022, N'El nombre es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@apellido_paterno)), '') IS NULL
            THROW 50023, N'El apellido paterno es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@apellido_materno)), '') IS NULL
            THROW 50024, N'El apellido materno es obligatorio.', 1;
        IF @fecha_nacimiento IS NULL
            THROW 50025, N'La fecha de nacimiento es obligatoria.', 1;
        IF @fecha_nacimiento > CONVERT(DATE, GETDATE())
            THROW 50026, N'La fecha de nacimiento no puede ser futura.', 1;
        IF NULLIF(LTRIM(RTRIM(@telefono)), '') IS NULL
            THROW 50027, N'El teléfono es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@correo_institucional)), '') IS NULL
            THROW 50028, N'El correo institucional es obligatorio.', 1;
        IF @semestre IS NULL OR @semestre < 1
            THROW 50029, N'El semestre debe ser mayor que cero.', 1;
        IF @foraneo IS NULL OR @becado IS NULL OR @estado IS NULL
            THROW 50030, N'Los indicadores foraneo, becado y estado son obligatorios.', 1;
        IF @idcarrera IS NULL OR @idcarrera < 1
            THROW 50031, N'La carrera indicada no es válida.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Alumno] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idalumno] = @idalumno
        )
            THROW 50032, N'No existe un alumno con esa matrícula.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Carrera] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idcarrera] = @idcarrera
        )
            THROW 50033, N'La carrera indicada no existe.', 1;

        UPDATE [dbo].[Alumno]
        SET [nombre] = @nombre,
            [apellido_paterno] = @apellido_paterno,
            [apellido_materno] = @apellido_materno,
            [fecha_nacimiento] = @fecha_nacimiento,
            [telefono] = @telefono,
            [correo_institucional] = @correo_institucional,
            [semestre] = @semestre,
            [foraneo] = @foraneo,
            [becado] = @becado,
            [estado] = @estado,
            [idcarrera] = @idcarrera
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
