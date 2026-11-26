CREATE PROCEDURE [dbo].[SP_UpdCarrera]
    @idcarrera INT,
    @nombre VARCHAR(80),
    @estado BIT,
    @idescuela INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idcarrera IS NULL OR @idcarrera < 1
            THROW 50121, N'El identificador de la carrera no es válido.', 1;
        IF NULLIF(LTRIM(RTRIM(@nombre)), '') IS NULL
            THROW 50122, N'El nombre de la carrera es obligatorio.', 1;
        IF @estado IS NULL
            THROW 50123, N'El estado es obligatorio.', 1;
        IF @idescuela IS NULL OR @idescuela < 1
            THROW 50124, N'La escuela indicada no es válida.', 1;

        SET @nombre = LTRIM(RTRIM(@nombre));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Carrera] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idcarrera] = @idcarrera
        )
            THROW 50125, N'No existe una carrera con ese identificador.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Escuela] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idescuela] = @idescuela
        )
            THROW 50126, N'La escuela indicada no existe.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Carrera] WITH (UPDLOCK, HOLDLOCK)
            WHERE [nombre] = @nombre
              AND [idcarrera] <> @idcarrera
        )
            THROW 50127, N'Ya existe otra carrera con ese nombre.', 1;

        UPDATE [dbo].[Carrera]
        SET [nombre] = @nombre,
            [estado] = @estado,
            [idescuela] = @idescuela
        WHERE [idcarrera] = @idcarrera;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO