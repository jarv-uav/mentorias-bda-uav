CREATE TABLE [dbo].[Carrera_Mentor](
	[Carreraidcarrera] [int] NOT NULL,
	[Mentoridmentor] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Carrera_Mentor] PRIMARY KEY CLUSTERED 
(
	[Carreraidcarrera] ASC,
	[Mentoridmentor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Carrera_Mentor]  WITH CHECK ADD  CONSTRAINT [FK_Carrera_Mentor_Carrera] FOREIGN KEY([Carreraidcarrera])
REFERENCES [dbo].[Carrera] ([idcarrera])
GO

ALTER TABLE [dbo].[Carrera_Mentor] CHECK CONSTRAINT [FK_Carrera_Mentor_Carrera]
GO

ALTER TABLE [dbo].[Carrera_Mentor]  WITH CHECK ADD  CONSTRAINT [FK_Carrera_Mentor_Mentor] FOREIGN KEY([Mentoridmentor])
REFERENCES [dbo].[Mentor] ([idmentor])
GO

ALTER TABLE [dbo].[Carrera_Mentor] CHECK CONSTRAINT [FK_Carrera_Mentor_Mentor]
GO