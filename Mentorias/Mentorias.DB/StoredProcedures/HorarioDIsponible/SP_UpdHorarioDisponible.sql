CREATE PROCEDURE [dbo].[SP_UpdHorarioDisponible]
    @idhorario INT,
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
        IF @idhorario IS NULL OR @idhorario < 1
            THROW 50221, N'El identificador del horario no es válido.', 1;
        IF NULLIF(LTRIM(RTRIM(@dia_semana)), '') IS NULL
            THROW 50222, N'El día de la semana es obligatorio.', 1;
        IF @hora_inicio IS NULL
            THROW 50223, N'La hora de inicio es obligatoria.', 1;
        IF @hora_fin IS NULL
            THROW 50224, N'La hora de fin es obligatoria.', 1;
        IF @hora_fin <= @hora_inicio
            THROW 50225, N'La hora de fin debe ser mayor que la hora de inicio.', 1;
        IF @fecha IS NULL
            THROW 50226, N'La fecha es obligatoria.', 1;
        IF @periodo IS NULL OR @periodo < 1
            THROW 50227, N'El periodo debe ser mayor que cero.', 1;
        IF @estado IS NULL
            THROW 50228, N'El estado es obligatorio.', 1;
        IF NULLIF(LTRIM(RTRIM(@idmentor)), '') IS NULL
            THROW 50229, N'El identificador del mentor es obligatorio.', 1;

        SET @dia_semana = UPPER(LTRIM(RTRIM(@dia_semana)));
        SET @idmentor = LTRIM(RTRIM(@idmentor));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[HorarioDisponible] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idhorario] = @idhorario
        )
            THROW 50230, N'No existe un horario con ese identificador.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentor] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idmentor
        )
            THROW 50231, N'El mentor indicado no existe.', 1;

        IF EXISTS (
            SELECT 1
            FROM [dbo].[HorarioDisponible] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idmentor
              AND [fecha] = @fecha
              AND [idhorario] <> @idhorario
              AND @hora_inicio < [hora_fin]
              AND @hora_fin > [hora_inicio]
        )
            THROW 50232, N'El mentor ya cuenta con otro horario que se empalma en esa fecha.', 1;

        UPDATE [dbo].[HorarioDisponible]
        SET [dia_semana] = @dia_semana,
            [hora_inicio] = @hora_inicio,
            [hora_fin] = @hora_fin,
            [fecha] = @fecha,
            [periodo] = @periodo,
            [estado] = @estado,
            [idmentor] = @idmentor
        WHERE [idhorario] = @idhorario;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO