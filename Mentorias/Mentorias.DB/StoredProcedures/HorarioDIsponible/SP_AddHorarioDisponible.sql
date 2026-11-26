CREATE PROCEDURE [dbo].[SP_AddHorarioDisponible]
    @dia_semana VARCHAR(3),
    @hora_inicio TIME(7),
    @hora_fin TIME(7),
    @fecha DATE,
    @periodo INT,
    @estado BIT,
    @idmentor VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NULLIF(LTRIM(RTRIM(@dia_semana)), '') IS NULL
            THROW 50201, N'El día de la semana es obligatorio.', 1;
        IF @hora_inicio IS NULL
            THROW 50202, N'La hora de inicio es obligatoria.', 1;
        IF @hora_fin IS NULL
            THROW 50203, N'La hora de fin es obligatoria.', 1;
        IF @hora_fin <= @hora_inicio
            THROW 50204, N'La hora de fin debe ser mayor que la hora de inicio.', 1;
        IF @fecha IS NULL
            THROW 50205, N'La fecha es obligatoria.', 1;
        IF @periodo IS NULL OR @periodo < 1
            THROW 50206, N'El periodo debe ser mayor que cero.', 1;
        IF @estado IS NULL
            THROW 50207, N'El estado es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@idmentor)), '') IS NULL
            THROW 50208, N'El identificador del mentor es obligatorio.', 1;

        SET @dia_semana = UPPER(LTRIM(RTRIM(@dia_semana)));
        SET @idmentor = LTRIM(RTRIM(@idmentor));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentor] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idmentor
        )
            THROW 50209, N'El mentor indicado no existe.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[HorarioDisponible] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idmentor
              AND [fecha] = @fecha
              AND @hora_inicio < [hora_fin]
              AND @hora_fin > [hora_inicio]
        )
            THROW 50210, N'El mentor ya cuenta con un horario que se empalma en esa fecha.', 1;

        INSERT INTO [dbo].[HorarioDisponible] (
            [dia_semana], [hora_inicio], [hora_fin],
            [fecha], [periodo], [estado], [idmentor]
        )
        VALUES (
            @dia_semana, @hora_inicio, @hora_fin,
            @fecha, @periodo, @estado, @idmentor
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