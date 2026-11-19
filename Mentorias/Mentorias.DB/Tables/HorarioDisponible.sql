CREATE TABLE [dbo].[HorarioDisponible](
	[idhorario] [int] NOT NULL,
	[dia_semana] [nvarchar](3) NOT NULL,
	[hora_inicio] [time](7) NOT NULL,
	[hora_fin] [time](7) NOT NULL,
	[fecha] [date] NOT NULL,
	[periodo] [int] NOT NULL,
	[estado] [bit] NOT NULL,
	[idmentor] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_HorarioDisponible] PRIMARY KEY CLUSTERED 
(
	[idhorario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[HorarioDisponible]  WITH CHECK ADD  CONSTRAINT [FK_HorarioDisponible_Mentor] FOREIGN KEY([idmentor])
REFERENCES [dbo].[Mentor] ([idmentor])
GO

ALTER TABLE [dbo].[HorarioDisponible] CHECK CONSTRAINT [FK_HorarioDisponible_Mentor]
GO