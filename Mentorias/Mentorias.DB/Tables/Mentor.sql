CREATE TABLE [dbo].[Mentor](
	[idmentor] [nvarchar](10) NOT NULL,
	[nombre] [nvarchar](20) NOT NULL,
	[apellido_paterno] [nvarchar](20) NOT NULL,
	[apellido_materno] [nvarchar](20) NOT NULL,
	[correo_institucional] [nvarchar](30) NOT NULL,
	[telefono] [nvarchar](15) NOT NULL,
	[estado] [bit] NOT NULL,
 CONSTRAINT [PK_Mentor] PRIMARY KEY CLUSTERED 
(
	[idmentor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

