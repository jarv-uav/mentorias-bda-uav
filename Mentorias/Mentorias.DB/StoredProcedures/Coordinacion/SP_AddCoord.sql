CREATE PROCEDURE [dbo].[SP_AddCoordinacion]
    @idcoordinador NVARCHAR(10),
    @nombre NVARCHAR(20),
    @apellido_paterno NVARCHAR(20),
    @apellido_materno NVARCHAR(20) = NULL,
    @correo_institucional NVARCHAR(20),
    @estado BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@idcoordinador)), '') IS NULL
            THROW 50101, N'El ID del coordinador es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@nombre)), '') IS NULL
            THROW 50102, N'El nombre es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@apellido_paterno)), '') IS NULL
            THROW 50103, N'El apellido paterno es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@correo_institucional)), '') IS NULL
            THROW 50104, N'El correo institucional es obligatorio.', 1;

        DECLARE @idCoordLimpio NVARCHAR(10) = LTRIM(RTRIM(@idcoordinador));
        DECLARE @nombreLimpio NVARCHAR(20) = LTRIM(RTRIM(@nombre));
        DECLARE @apPatLimpio NVARCHAR(20) = LTRIM(RTRIM(@apellido_paterno));
        DECLARE @apMatLimpio NVARCHAR(20) = NULLIF(LTRIM(RTRIM(@apellido_materno)), '');
        DECLARE @correoLimpio NVARCHAR(20) = LTRIM(RTRIM(@correo_institucional));

        BEGIN TRANSACTION;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Coordinacion] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idcoordinador] = @idCoordLimpio
        )
            THROW 50105, N'Ya existe un registro en Coordinacion con ese ID.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Coordinacion] WITH (UPDLOCK, HOLDLOCK)
            WHERE [correo_institucional] = @correoLimpio
        )
            THROW 50106, N'Ya existe un registro con ese correo institucional.', 1;

        INSERT INTO [dbo].[Coordinacion] (
            [idcoordinador],
            [nombre],
            [apellido_paterno],
            [apellido_materno],
            [correo_institucional],
            [estado]
        )
        VALUES (
            @idCoordLimpio,
            @nombreLimpio,
            @apPatLimpio,
            @apMatLimpio,
            @correoLimpio,
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