USE [DevTest]
GO

/****** Object:  Table [dbo].[fooditems]    Script Date: 2024-10-28 2:51:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[fooditems](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[food_name] [varchar](255) NOT NULL,
	[quantity] [int] NOT NULL,
	[expiration_date] [date] NOT NULL,
	[restaurant_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO