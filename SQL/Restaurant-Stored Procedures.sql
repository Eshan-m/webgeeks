USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[InsertFoodItem]    Script Date: 2024-10-28 4:24:14 PM ******/
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