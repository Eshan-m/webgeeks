
/****** Object:  StoredProcedure [dbo].[ARGetUserAuthority]    Script Date: 2024-11-26 8:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ARGetUserAuthority]
    @Username NVARCHAR(100),  -- Adjust the size according to your database schema
    @Password NVARCHAR(100)    -- Adjust the size according to your database schema
AS
BEGIN
    DECLARE @UserType NVARCHAR(50);
    DECLARE @result INT;

    -- Check if the user exists and retrieve their user type
    SELECT @UserType = UserType
    FROM Users
    WHERE UserName = @Username AND Password = @Password;

    -- Determine the result based on user type
    IF @UserType IS NOT NULL
    BEGIN
        IF @UserType = 'customer'
        BEGIN
            SET @result = 1;  -- User is a customer

			Select @result
        END
        ELSE IF @UserType = 'restaurant'
        BEGIN
            SET @result = 2;
			Select @result-- User is a restaurant owner
        END
    END
    ELSE
    BEGIN
        SET @result = 0;  -- User does not exist
		Select @result
    END

  -- Return the result
END



/****** Object:  StoredProcedure [dbo].[DeleteFoodItemById]    Script Date: 2024-11-26 8:15:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DeleteFoodItemById]
    @foodItemId int  -- Adjust the size according to your database schema    -- Adjust the size according to your database schema
AS
BEGIN
    DELETE FROM fooditems
    WHERE id = @foodItemId
END



/****** Object:  StoredProcedure [dbo].[GetFoodItemById]    Script Date: 2024-11-26 8:15:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetFoodItemById]
    @FoodItemId INT
AS
BEGIN
    SELECT food_name, Quantity, expiration_date
    FROM fooditems
    WHERE Id = @FoodItemId;
END;



/****** Object:  StoredProcedure [dbo].[GetFoodItems]    Script Date: 2024-11-26 8:15:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetFoodItems]
AS
BEGIN
    SELECT 
        id,
        food_name,
        quantity,
        expiration_date,
        restaurant_id
    FROM 
        fooditems;
END



/****** Object:  StoredProcedure [dbo].[GetFoodItemsByRestaurant]    Script Date: 2024-11-26 8:16:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetFoodItemsByRestaurant]
    @UserName NVARCHAR(100)
AS
BEGIN
    -- Get the UserId (RestaurantId) from Users table
    DECLARE @RestaurantId INT;
    
    SELECT @RestaurantId = UserId 
    FROM Users 
    WHERE UserName = @UserName;

    -- If the restaurant doesn't exist, return an empty result set
    IF @RestaurantId IS NULL
    BEGIN
        SELECT 'Restaurant not found' AS Message;
        RETURN;
    END

    -- Retrieve food items associated with the restaurant's UserId
    SELECT 
	    id,
        food_name, 
        Quantity, 
        expiration_date
    FROM FoodItems
    WHERE restaurant_id = @RestaurantId;
END;



/****** Object:  StoredProcedure [dbo].[GetOrdersByRestaurantUsername]    Script Date: 2024-11-26 8:16:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetOrdersByRestaurantUsername]
    @RestaurantUsername NVARCHAR(50)
AS
BEGIN
    SELECT o.RecId, o.Username, o.Quantity, o.Restaurant_id, o.CreatedAt, o.FoodName
    FROM Orders o
    INNER JOIN Users u ON o.Restaurant_id = u.UserId
    WHERE u.UserName = @RestaurantUsername AND u.UserType = 'restaurant';
END;



/****** Object:  StoredProcedure [dbo].[GetOrdersByUsername]    Script Date: 2024-11-26 8:16:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetOrdersByUsername]
    @Username NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RecId,
        Username,
        Quantity,
        Restaurant_id,
        CreatedAt,
		FoodName
    FROM 
        [dbo].[Orders]
    WHERE 
        Username = @Username
    ORDER BY 
        CreatedAt DESC;
END



/****** Object:  StoredProcedure [dbo].[Getresturants]    Script Date: 2024-11-26 8:16:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Getresturants]
AS
BEGIN
    SELECT 
        USERNAME, UserType, USERID
    FROM 
        Users where UserType='restaurant';
END



/****** Object:  StoredProcedure [dbo].[InsertFoodItem]    Script Date: 2024-11-26 8:17:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[InsertFoodItem]
    @FoodName NVARCHAR(100),
    @Quantity INT,
    @ExpiryDate DATE,
    @Condition NVARCHAR(50),
    @User NVARCHAR(100)  -- Accept the restaurant's username
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RestaurantId INT;

    -- Get the UserId (RestaurantId) from the Users table
    SELECT @RestaurantId = UserId 
    FROM Users 
    WHERE UserName = @User;

    -- Check if the restaurant exists
    IF (@RestaurantId IS NULL)
    BEGIN
        SELECT 'Error: Restaurant not found' AS Result;
        RETURN;
    END

    -- Insert the new food item along with the RestaurantId
    INSERT INTO fooditems (food_name, Quantity, expiration_date, restaurant_id)
    VALUES (@FoodName, @Quantity, @ExpiryDate, @RestaurantId);

    -- Return a success message
    SELECT 'Food item added successfully' AS Result;
END



/****** Object:  StoredProcedure [dbo].[InsertOrderAndUpdateFoodItem]    Script Date: 2024-11-26 8:17:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[InsertOrderAndUpdateFoodItem]
    @Username NVARCHAR(50),
    @FoodItemId INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentQuantity INT;
    DECLARE @RestaurantId INT;
	DeCLARE @Food varchar(50);

    -- Step 1: Get the current quantity and restaurant_id from fooditems table for the given food item ID
    SELECT 
        @CurrentQuantity = quantity, 
        @RestaurantId = restaurant_id,
		@Food = food_name
    FROM [dbo].[fooditems]
    WHERE id = @FoodItemId;

    -- Step 2: Check if there is enough quantity to fulfill the order
    IF @CurrentQuantity IS NULL
    BEGIN
        RAISERROR ('Food item not found', 16, 1);
        RETURN;
    END

    IF @CurrentQuantity < @Quantity
    BEGIN
        RAISERROR ('Insufficient quantity available', 16, 1);
        RETURN;
    END

    -- Step 3: Update the fooditems table, reducing the quantity
    UPDATE [dbo].[fooditems]
    SET quantity = quantity - @Quantity
    WHERE id = @FoodItemId;

    -- Step 4: Insert a new record into the Orders table
    INSERT INTO Orders (Username, Quantity, Restaurant_id, CreatedAt, FoodName)
    VALUES (@Username, @Quantity, @RestaurantId, GETDATE(), @Food);
END



/****** Object:  StoredProcedure [dbo].[InsertUser]    Script Date: 2024-11-26 8:17:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[InsertUser]
    @UserName NVARCHAR(100),
    @Password NVARCHAR(255),
    @Email NVARCHAR(255),
    @UserType NVARCHAR(50)
AS
BEGIN
    -- Start a transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the username already exists
        IF EXISTS (SELECT 1 FROM Users WHERE UserName = @UserName)
        BEGIN
            RAISERROR('Username already exists. Please choose a different username.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insert the user data into the Users table
        INSERT INTO Users (UserName, Password, Email, UserType)
        VALUES (@UserName, @Password, @Email, @UserType);
        
        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Handle errors
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;



/****** Object:  StoredProcedure [dbo].[UpdateFoodItemById]    Script Date: 2024-11-26 8:18:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UpdateFoodItemById]
    @FoodItemId INT,
    @FoodName NVARCHAR(100),
    @Quantity INT
AS
BEGIN
    UPDATE fooditems
    SET 
        food_name = @FoodName,
        quantity = @Quantity
    WHERE 
        id = @FoodItemId;
END;
