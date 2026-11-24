CREATE PROCEDURE [dbo].[SP_UpdSemaforo]
    @idsemaforo INT,
    @semaforo NVARCHAR(10),
    @descripcion NVARCHAR(50) = NULL,
    @color NVARCHAR(6) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idsemaforo IS NULL OR @idsemaforo < 1
            THROW 50021, N'El identificador de semáforo no es válido.', 1;
        IF @semaforo IS NULL OR LTRIM(RTRIM(@semaforo)) = N''
            THROW 50022, N'El semáforo es obligatorio.', 1;

        SET @semaforo = LTRIM(RTRIM(@semaforo));
        IF @color IS NOT NULL AND LTRIM(RTRIM(@color)) = N''
            SET @color = NULL;
        ELSE IF @color IS NOT NULL
            SET @color = LTRIM(RTRIM(@color));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idsemaforo] = @idsemaforo
        )
            THROW 50023, N'No existe un registro de semáforo con ese identificador.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
            WHERE [semaforo] = @semaforo
              AND [idsemaforo] <> @idsemaforo
        )
            THROW 50024, N'Ya existe otro registro de semáforo con ese valor.', 1;

        IF @color IS NOT NULL
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
                WHERE [color] = @color
                  AND [idsemaforo] <> @idsemaforo
            )
                THROW 50025, N'Ya existe otro registro de semáforo con ese color.', 1;
        END;

        UPDATE [dbo].[Semaforo]
        SET [semaforo] = @semaforo,
            [descripcion] = @descripcion,
            [color] = @color
        WHERE [idsemaforo] = @idsemaforo;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO