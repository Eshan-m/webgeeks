/* Tables.sql */

CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	  NOT NULL,
CLUSTERED ([ TABLE [dbo] IDENTITY(1,1) NOT NULL,
	  NOT NULL,
	[quantity] [int] NOT NULL,
	[expiration_date] [date] NOT NULL,
	[restaurant_id] [inCLUSTERED ([id] ASC)
);

CREATE TABLE [dbo].[Orders](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	  NOT NULL,
	[Quantity] [int] NOT NULL,
	[Restaurant_id] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	  NOT NULL,
	cId] ASC)
);



