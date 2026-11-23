CREATE PROCEDURE [dbo].[SP_AddMentor]
    @idmentor NVARCHAR(10),
    @nombre NVARCHAR(20),
    @apellido_paterno NVARCHAR(20),
    @apellido_materno NVARCHAR(20),
    @correo_institucional NVARCHAR(30),
    @telefono NVARCHAR(15),
    @estado BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@idmentor)), '') IS NULL
            THROW 50201, N'El ID del mentor es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@nombre)), '') IS NULL
            THROW 50202, N'El nombre es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@apellido_paterno)), '') IS NULL
            THROW 50203, N'El apellido paterno es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@apellido_materno)), '') IS NULL
            THROW 50204, N'El apellido materno es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@correo_institucional)), '') IS NULL
            THROW 50205, N'El correo institucional es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@telefono)), '') IS NULL
            THROW 50206, N'El teléfono es obligatorio.', 1;
        IF @estado IS NULL
            THROW 50207, N'El estado del mentor es obligatorio.', 1;

        DECLARE @idMentorLimpio NVARCHAR(10) = LTRIM(RTRIM(@idmentor));
        DECLARE @nombreLimpio NVARCHAR(20) = LTRIM(RTRIM(@nombre));
        DECLARE @apPatLimpio NVARCHAR(20) = LTRIM(RTRIM(@apellido_paterno));
        DECLARE @apMatLimpio NVARCHAR(20) = LTRIM(RTRIM(@apellido_materno));
        DECLARE @correoLimpio NVARCHAR(30) = LTRIM(RTRIM(@correo_institucional));
        DECLARE @telefonoLimpio NVARCHAR(15) = LTRIM(RTRIM(@telefono));

        BEGIN TRANSACTION;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Mentor] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idMentorLimpio
        )
            THROW 50208, N'Ya existe un mentor con ese ID.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Mentor] WITH (UPDLOCK, HOLDLOCK)
            WHERE [correo_institucional] = @correoLimpio
        )
            THROW 50209, N'Ya existe un mentor con ese correo institucional.', 1;

        INSERT INTO [dbo].[Mentor] (
            [idmentor],
            [nombre],
            [apellido_paterno],
            [apellido_materno],
            [correo_institucional],
            [telefono],
            [estado]
        )
        VALUES (
            @idMentorLimpio,
            @nombreLimpio,
            @apPatLimpio,
            @apMatLimpio,
            @correoLimpio,
            @telefonoLimpio,
            @estado
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