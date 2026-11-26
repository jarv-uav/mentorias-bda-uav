CREATE PROCEDURE [dbo].[SP_AddEstadoMentoria]
    @idestado INT,
    @estado VARCHAR(15),
    @descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idestado IS NULL OR @idestado < 1
            THROW 50061, N'El identificador del estado de mentoría no es válido.', 1;
        IF NULLIF(LTRIM(RTRIM(@estado)), '') IS NULL
            THROW 50062, N'El estado de mentoría es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@descripcion)), '') IS NULL
            THROW 50063, N'La descripción del estado de mentoría es obligatoria.', 1;

        BEGIN TRANSACTION;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idestado] = @idestado
        )
            THROW 50064, N'Ya existe un estado de mentoría con ese identificador.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [estado] = @estado
        )
            THROW 50065, N'Ya existe un estado de mentoría con ese nombre.', 1;

        INSERT INTO [dbo].[EstadoMentoria] (
            [idestado],
            [estado],
            [descripcion]
        )
        VALUES (
            @idestado,
            @estado,
            @descripcion
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