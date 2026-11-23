CREATE PROCEDURE [dbo].[SP_AddSemaforo]
    @semaforo NVARCHAR(10),
    @descripcion NVARCHAR(50) = NULL,
    @color NVARCHAR(6) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @semaforo IS NULL OR LTRIM(RTRIM(@semaforo)) = N''
            THROW 50001, N'El semáforo es obligatorio.', 1;

        SET @semaforo = LTRIM(RTRIM(@semaforo));
        IF @color IS NOT NULL AND LTRIM(RTRIM(@color)) = N''
            SET @color = NULL;
        ELSE IF @color IS NOT NULL
            SET @color = LTRIM(RTRIM(@color));

        BEGIN TRANSACTION;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
            WHERE [semaforo] = @semaforo
        )
            THROW 50002, N'Ya existe un registro de semáforo con ese valor.', 1;

        IF @color IS NOT NULL
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
                WHERE [color] = @color
            )
                THROW 50003, N'Ya existe un registro de semáforo con ese color.', 1;
        END;

        INSERT INTO [dbo].[Semaforo] (
            [semaforo], [descripcion], [color]
        )
        VALUES (
            @semaforo, @descripcion, @color
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