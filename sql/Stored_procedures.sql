-- Stored_procedures.sql
-- Check Login Procedure
CREATE PROCEDURE [dbo].[ARGetUserAuthority]
    @Username NVARCHAR(100),
    @Password NVARCHAR(100)
AS
BEGIN
    DECLARE @UserType NVARCHAR(50);
    DECLARE @result INT;

    SELECT @UserType = UserType
    FROM Users
    WHERE UserName = @Username AND Password = @Password;

    IF @UserType IS NOT NULL
    BEGIN
        IF @UserType = 'customer'
        BEGIN
            SET @result = 1;
            SELECT @result;
        END
        ELSE IF @UserType = 'restaurant'
        BEGIN
            SET @result = 2;
            SELECT @result;
        END
    END
    ELSE
    BEGIN
        SET @result = 0;
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
    BEGIN TRANSACTION;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Users WHERE UserName = @UserName)
        BEGIN
            RAISERROR('Username already exists. Please choose a different username.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Users (UserName, Password, Email, UserType)
        VALUES (@UserName, @Password, @Email, @UserType);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
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

-- Retrieve food items for a restaurant
CREATE PROCEDURE [dbo].[GetFoodItemsByRestaurant]
    @UserName NVARCHAR(100)
AS
BEGIN
    DECLARE @RestaurantId INT;
    
    SELECT @RestaurantId = UserId 
    FROM Users 
    WHERE UserName = @UserName;

    IF @RestaurantId IS NULL
    BEGIN
        SELECT 'Restaurant not found' AS Message;
        RETURN;
    END

    SELECT 
        food_name, 
        Quantity, 
        expiration_date
    FROM fooditems
    WHERE restaurant_id = @RestaurantId;
END;
GO

-- Insert a new food item
CREATE PROCEDURE [dbo].[InsertFoodItem]
    @FoodName NVARCHAR(100),
    @Quantity INT,
    @ExpiryDate DATE,
    @User NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RestaurantId INT;

    SELECT @RestaurantId = UserId 
    FROM Users 
    WHERE UserName = @User;

    IF (@RestaurantId IS NULL)
    BEGIN
        SELECT 'Error: Restaurant not found' AS Result;
        RETURN;
    END

    INSERT INTO fooditems (food_name, Quantity, expiration_date, restaurant_id)
    VALUES (@FoodName, @Quantity, @ExpiryDate, @RestaurantId);

    SELECT 'Food item added successfully' AS Result;
END;
GO

-- Retrieve orders by restaurant username
CREATE PROCEDURE [dbo].[GetOrdersByRestaurantUsername]
    @RestaurantUsername NVARCHAR(50)
AS
BEGIN
    SELECT o.RecId, o.Username, o.Quantity, o.Restaurant_id, o.CreatedAt, o.FoodName
    FROM Orders o
    INNER JOIN Users u ON o.Restaurant_id = u.UserId
    WHERE u.UserName = @RestaurantUsername AND u.UserType = 'restaurant';
END;
GO



