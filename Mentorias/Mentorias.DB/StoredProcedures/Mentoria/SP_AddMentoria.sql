CREATE PROCEDURE [dbo].[SP_AddMentoria]
    @fecha_propuesta DATE,
    @hora_propuesta TIME(7),
    @motivo INT = NULL,
    @presencial BIT = 1,
    @observaciones NVARCHAR(500) = NULL,
    @idestado INT,
    @idsemaforo INT,
    @idalumno NVARCHAR(10),
    @idmentor NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @fecha_propuesta IS NULL
            THROW 50001, N'La fecha propuesta es obligatoria.', 1;
        IF @hora_propuesta IS NULL
            THROW 50002, N'La hora propuesta es obligatoria.', 1;
        IF @motivo IS NOT NULL AND @motivo < 1
            THROW 50003, N'El motivo indicado no es válido.', 1;
        IF @presencial IS NULL
            THROW 50004, N'El indicador presencial es obligatorio.', 1;
        IF @idestado IS NULL OR @idestado < 1
            THROW 50005, N'El estado de mentoría indicado no es válido.', 1;
        IF @idsemaforo IS NULL OR @idsemaforo < 1
            THROW 50006, N'El semáforo indicado no es válido.', 1;
        IF @idalumno IS NULL OR LTRIM(RTRIM(@idalumno)) = N''
            THROW 50007, N'El alumno indicado no es válido.', 1;
        IF @idmentor IS NULL OR LTRIM(RTRIM(@idmentor)) = N''
            THROW 50008, N'El mentor indicado no es válido.', 1;

        SET @idalumno = LTRIM(RTRIM(@idalumno));
        SET @idmentor = LTRIM(RTRIM(@idmentor));

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[EstadoMentoria] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idestado] = @idestado
        )
            THROW 50009, N'El estado de mentoría indicado no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Semaforo] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idsemaforo] = @idsemaforo
        )
            THROW 50010, N'El semáforo indicado no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Alumno] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idalumno] = @idalumno
        )
            THROW 50011, N'El alumno indicado no existe.', 1;

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Mentor] WITH (UPDLOCK, HOLDLOCK)
            WHERE [idmentor] = @idmentor
        )
            THROW 50012, N'El mentor indicado no existe.', 1;

        INSERT INTO [dbo].[Mentoria] (
            [fecha_propuesta], [hora_propuesta], [motivo], [presencial],
            [observaciones], [idestado], [idsemaforo], [idalumno], [idmentor]
        )
        VALUES (
            @fecha_propuesta, @hora_propuesta, @motivo, @presencial,
            @observaciones, @idestado, @idsemaforo, @idalumno, @idmentor
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