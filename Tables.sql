CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[UserType] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FoodItems] (
    [Id] BIGINT IDENTITY(1,1) NOT NULL,                       -- Primary Key, auto-incrementing
    [RestaurantId] INT NOT NULL,                              -- Foreign Key (references Users.UserId)
    [Name] NVARCHAR(255) NOT NULL,                            -- Name of the food item
    [Quantity] INT NOT NULL,                                  -- Quantity available for the food item
    [Condition] NVARCHAR(50) NOT NULL CHECK ([Condition] IN ('fresh', 'near-expiry')), -- Condition of the food item
    [ExpiryDate] DATE NOT NULL,                               -- Expiration date of the food item
    [Status] NVARCHAR(50) DEFAULT 'available' CHECK ([Status] IN ('available', 'claimed', 'expired')), -- Status of the food item
    [Address] NVARCHAR(255),                                  -- Address of the restaurant
    [CreatedAt] DATETIME DEFAULT CURRENT_TIMESTAMP,           -- Timestamp when the food item was listed
    [UpdatedAt] DATETIME DEFAULT CURRENT_TIMESTAMP,           -- Timestamp for last update (manual trigger required for updates)
    CONSTRAINT [PK_FoodItems] PRIMARY KEY CLUSTERED 
    (
        [Id] ASC
    )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
) ON [PRIMARY];

-- Establish the foreign key relationship with the Users table
ALTER TABLE [dbo].[FoodItems]
ADD CONSTRAINT [FK_FoodItems_Users]
FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Users]([UserId]);
