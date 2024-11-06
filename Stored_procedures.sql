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
/****** Object:  StoredProcedure [dbo].[InsertOrderAndUpdateFoodItem]    Script Date: 2024-11-05 7:54:35 PM ******/
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


USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetOrdersByUsername]    Script Date: 2024-11-05 7:55:13 PM ******/
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

