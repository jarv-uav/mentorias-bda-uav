CREATE TABLE [dbo].[Alumno](
	[idalumno] [varchar](10) NOT NULL,
	[nombre] [varchar](20) NOT NULL,
	[apellido_paterno] [varchar](20) NOT NULL,
	[apellido_materno] [varchar](20) NOT NULL,
	[fecha_nacimiento] [date] NOT NULL,
	[telefono] [varchar](15) NOT NULL,
	[correo_institucional] [varchar](30) NOT NULL,
	[semestre] [int] NOT NULL,
	[foraneo] [bit] NOT NULL,
	[becado] [bit] NOT NULL,
	[estado] [bit] NOT NULL,
	[idcarrera] [int] NOT NULL,
 CONSTRAINT [PK_Alumno] PRIMARY KEY CLUSTERED 
(
	[idalumno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Alumno]  WITH CHECK ADD  CONSTRAINT [FK_Alumno_Carrera] FOREIGN KEY([idcarrera])
REFERENCES [dbo].[Carrera] ([idcarrera])
GO

ALTER TABLE [dbo].[Alumno] CHECK CONSTRAINT [FK_Alumno_Carrera]
GO

