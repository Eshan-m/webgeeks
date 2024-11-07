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



USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItems]    Script Date: 2024-10-31 5:14:22 PM ******/
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

USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItemsByRestaurant]    Script Date: 2024-10-31 5:14:39 PM ******/
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
        food_name, 
        Quantity, 
        expiration_date
    FROM FoodItems
    WHERE restaurant_id = @RestaurantId;
END;


USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[InsertFoodItem]    Script Date: 2024-10-31 5:14:57 PM ******/
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



