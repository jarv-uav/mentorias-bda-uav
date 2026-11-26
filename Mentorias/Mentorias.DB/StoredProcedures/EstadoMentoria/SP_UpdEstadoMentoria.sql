CREATE PROCEDURE [dbo].[SP_UpdEstadoMentoria]
    @idestado INT,
    @estado VARCHAR(15),
    @descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idestado IS NULL OR @idestado < 1
            THROW 50067, N'El identificador del estado de mentoría no es válido.', 1;
        IF NULLIF(LTRIM(RTRIM(@estado)), '') IS NULL
            THROW 50068, N'El estado de mentoría es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@descripcion)), '') IS NULL
            THROW 50069, N'La descripción del estado de mentoría es obligatoria.', 1;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idestado] = @idestado
        )
            THROW 50070, N'No existe un estado de mentoría con ese identificador.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [estado] = @estado
              AND [idestado] <> @idestado
        )
            THROW 50071, N'Ya existe otro estado de mentoría con ese nombre.', 1;

        UPDATE [dbo].[EstadoMentoria]
        SET [estado] = @estado,
            [descripcion] = @descripcion
        WHERE [idestado] = @idestado;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO