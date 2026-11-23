CREATE TABLE dbo.Mentoria (
    idmentoria INT IDENTITY(1,1) NOT NULL,
    fecha_propuesta DATE NOT NULL,
    hora_propuesta TIME(7) NOT NULL,
    motivo INT NULL,
    presencial BIT DEFAULT 1 NOT NULL,
    observaciones VARCHAR(500) NULL,
    idestado INT NOT NULL,
    idsemaforo INT NOT NULL,
    idalumno INT NOT NULL,
    idmentor INT NOT NULL,
    CONSTRAINT PK_Mentoria PRIMARY KEY CLUSTERED (idmentoria ASC),
    CONSTRAINT FK_Mentoria_Estado FOREIGN KEY (idestado) REFERENCES dbo.EstadoMentoria(idestado),
    CONSTRAINT FK_Mentoria_Semaforo FOREIGN KEY (idsemaforo) REFERENCES dbo.Semaforo(idsemaforo),
    CONSTRAINT FK_Mentoria_Alumno FOREIGN KEY (idalumno) REFERENCES dbo.Alumno(idalumno),
    CONSTRAINT FK_Mentoria_Mentor FOREIGN KEY (idmentor) REFERENCES dbo.Mentor(idmentor)
);
GO