CREATE PROCEDURE [dbo].[SP_AddCarrera]
    @nombre VARCHAR(80),
    @estado BIT,
    @idescuela INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@nombre)), '') IS NULL
            THROW 50101, N'El nombre de la carrera es obligatorio.', 1;
        IF @estado IS NULL
            THROW 50102, N'El estado es obligatorio.', 1;
        IF @idescuela IS NULL OR @idescuela < 1
            THROW 50103, N'La escuela indicada no es válida.', 1;

        SET @nombre = LTRIM(RTRIM(@nombre));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Escuela] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idescuela] = @idescuela
        )
            THROW 50104, N'La escuela indicada no existe.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Carrera] WITH (UPDLOCK, HOLDLOCK)
            WHERE [nombre] = @nombre
        )
            THROW 50105, N'Ya existe una carrera con ese nombre.', 1;

        INSERT INTO [dbo].[Carrera] (
            [nombre], [estado], [idescuela]
        )
        VALUES (
            @nombre, @estado, @idescuela
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