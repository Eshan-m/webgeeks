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

CREATE PROCEDURE [dbo].[InsertFoodItem]
    @RestaurantId INT,
    @Name NVARCHAR(255),
    @Quantity INT,
    @Condition NVARCHAR(50),
    @ExpiryDate DATE,
    @Address NVARCHAR(255),
    @Status NVARCHAR(50) = 'available'  -- Default value is 'available'
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Verify the restaurant exists
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserId = @RestaurantId AND UserType = 'restaurant')
        BEGIN
            RAISERROR('Restaurant not found or invalid user type.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insert the food item
        INSERT INTO FoodItems (RestaurantId, Name, Quantity, Condition, ExpiryDate, Address, Status)
        VALUES (@RestaurantId, @Name, @Quantity, @Condition, @ExpiryDate, @Address, @Status);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback and raise error if an exception occurs
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

CREATE PROCEDURE [dbo].[UpdateFoodItemStatus]
    @FoodItemId BIGINT,
    @Status NVARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update the status if it's a valid food item
        IF EXISTS (SELECT 1 FROM FoodItems WHERE Id = @FoodItemId)
        BEGIN
            UPDATE FoodItems
            SET Status = @Status, UpdatedAt = CURRENT_TIMESTAMP
            WHERE Id = @FoodItemId;
            COMMIT TRANSACTION;
        END
        ELSE
        BEGIN
            RAISERROR('Food item not found.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END TRY
    BEGIN CATCH
        -- Handle errors
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

CREATE PROCEDURE [dbo].[GetFoodItemsByRestaurant]
    @RestaurantId INT,
    @Status NVARCHAR(50) = NULL  -- Optional: filter by status
AS
BEGIN
    SELECT Id, Name, Quantity, Condition, ExpiryDate, Status, Address, CreatedAt, UpdatedAt
    FROM FoodItems
    WHERE RestaurantId = @RestaurantId
    AND (@Status IS NULL OR Status = @Status);
END;
GO

