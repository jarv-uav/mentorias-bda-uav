CREATE TABLE [dbo].[Carrera](
	[idcarrera] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](80) NOT NULL,
	[estado] [bit] NOT NULL,
	[idescuela] [int] NOT NULL,
 CONSTRAINT [PK_Carrera] PRIMARY KEY CLUSTERED 
(
	[idcarrera] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Carrera]  WITH CHECK ADD  CONSTRAINT [FK_Carrera_Escuela] FOREIGN KEY([idescuela])
REFERENCES [dbo].[Escuela] ([idescuela])
GO

ALTER TABLE [dbo].[Carrera] CHECK CONSTRAINT [FK_Carrera_Escuela]
GO

