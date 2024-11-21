-- Check Login Procedure
CREATE PROCEDURE [dbo].[ARGetUserAuthority]
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
            SELECT @result;
        END
        ELSE IF @UserType = 'restaurant'
        BEGIN
            SET @result = 2;  -- User is a restaurant owner
            SELECT @result;
        END
        ELSE IF @UserType = 'admin'
        BEGIN
            SET @result = 3;  -- User is a admin
            SELECT @result;
        END
    END
    ELSE
    BEGIN
        SET @result = 0;  -- User does not exist
        SELECT @result;
    END
END;
GO


-- User Registration Procedure
CREATE PROCEDURE [dbo].[InsertUser]
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
GO

--INSERT FOOD Procedure
USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[InsertFoodItem]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertFoodItem]
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

--GET FOOD ITEMS Procedure
USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItemsByRestaurant]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFoodItemsByRestaurant]
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

--GET FOOD Procedure
USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItemById] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFoodItemById]
    @FoodItemId INT
AS
BEGIN
    SELECT food_name, Quantity, expiration_date
    FROM fooditems
    WHERE Id = @FoodItemId;
END;
GO

--GET FOOD ITEMS  Procedure
USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItems]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFoodItems]
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

--DELETE FOOD Procedure
USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[DeleteFoodItemById] ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFoodItemById]
    @foodItemId INT
AS
BEGIN
    DELETE FROM fooditems
    WHERE id = @foodItemId;
END;
GO

--UPDATE FOOD Procedure
USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[UpdateFoodItemById] ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFoodItemById]
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
GO

--Get Orders By resturant
USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetOrdersByUsername]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOrdersByUsername]
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

CREATE PROCEDURE GetOrdersByRestaurantUsername
    @RestaurantUsername NVARCHAR(50)
AS
BEGIN
    SELECT o.RecId, o.Username, o.Quantity, o.Restaurant_id, o.CreatedAt, o.FoodName
    FROM Orders o
    INNER JOIN Users u ON o.Restaurant_id = u.UserId
    WHERE u.UserName = @RestaurantUsername AND u.UserType = 'restaurant';
END;

CREATE PROCEDURE [dbo].[GetAdminStatistics]
AS
BEGIN
    SET NOCOUNT ON;

    -- Total number of users
    DECLARE @TotalUsers INT;
    SELECT @TotalUsers = COUNT(*) FROM dbo.Users;

    -- Total number of restaurants
    DECLARE @TotalRestaurants INT;
    SELECT @TotalRestaurants = COUNT(*)
    FROM dbo.Users
    WHERE UserType = 'Restaurant';

    -- Total number of food items
    DECLARE @TotalFoodItems INT;
    SELECT @TotalFoodItems = COUNT(*) FROM dbo.FoodItems;

    -- Add any other statistics as needed
    DECLARE @ExpiredItems INT;
    SELECT @ExpiredItems = COUNT(*)
    FROM dbo.FoodItems
    WHERE expiration_date < GETDATE();

    -- Return results
    SELECT
        @TotalUsers AS TotalUsers,
        @TotalRestaurants AS TotalRestaurants,
        @TotalFoodItems AS TotalFoodItems,
        @ExpiredItems AS ExpiredItems;
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsers]
AS
BEGIN
    SELECT 
        UserId,
        UserName,
        Email,
        UserType
    FROM 
        Users;
END
GO



USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItems]    Script Date: 2024-11-20 10:47:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Alter PROCEDURE [dbo].[Getresturants]
AS
BEGIN
    SELECT 
        USERNAME, UserType, USERID
    FROM 
        Users where UserType='restaurant';
END

