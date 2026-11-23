CREATE PROCEDURE [dbo].[SP_UpdMentoria]
    @idmentoria INT,
    @fecha_propuesta DATE,
    @hora_propuesta TIME(7),
    @motivo INT = NULL,
    @presencial BIT = 1,
    @observaciones VARCHAR(500) = NULL,
    @idestado INT,
    @idsemaforo INT,
    @idalumno NVARCHAR(10),
    @idmentor NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @idmentoria IS NULL OR @idmentoria < 1
            THROW 50021, N'El identificador de mentoría no es válido.', 1;
        IF @fecha_propuesta IS NULL
            THROW 50022, N'La fecha propuesta es obligatoria.', 1;
        IF @hora_propuesta IS NULL
            THROW 50023, N'La hora propuesta es obligatoria.', 1;
        IF @motivo IS NOT NULL AND @motivo < 1
            THROW 50024, N'El motivo indicado no es válido.', 1;
        IF @presencial IS NULL
            THROW 50025, N'El indicador presencial es obligatorio.', 1;
        IF @idestado IS NULL OR @idestado < 1
            THROW 50026, N'El estado de mentoría indicado no es válido.', 1;
        IF @idsemaforo IS NULL OR @idsemaforo < 1
            THROW 50027, N'El semáforo indicado no es válido.', 1;
        IF @idalumno IS NULL OR LTRIM(RTRIM(@idalumno)) = N''
            THROW 50028, N'El alumno indicado no es válido.', 1;
        IF @idmentor IS NULL OR LTRIM(RTRIM(@idmentor)) = N''
            THROW 50029, N'El mentor indicado no es válido.', 1;

        SET @idalumno = LTRIM(RTRIM(@idalumno));
        SET @idmentor = LTRIM(RTRIM(@idmentor));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentoria] = @idmentoria
        )
            THROW 50030, N'No existe una mentoría con ese identificador.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idestado] = @idestado
        )
            THROW 50031, N'El estado de mentoría indicado no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idsemaforo] = @idsemaforo
        )
            THROW 50032, N'El semáforo indicado no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Alumno] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idalumno] = @idalumno
        )
            THROW 50033, N'El alumno indicado no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentor] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idmentor
        )
            THROW 50034, N'El mentor indicado no existe.', 1;

        UPDATE [dbo].[Mentoria]
        SET [fecha_propuesta] = @fecha_propuesta,
            [hora_propuesta] = @hora_propuesta,
            [motivo] = @motivo,
            [presencial] = @presencial,
            [observaciones] = @observaciones,
            [idestado] = @idestado,
            [idsemaforo] = @idsemaforo,
            [idalumno] = @idalumno,
            [idmentor] = @idmentor
        WHERE [idmentoria] = @idmentoria;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO