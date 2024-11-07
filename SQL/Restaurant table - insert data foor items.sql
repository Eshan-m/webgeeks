USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItemsByRestaurant]    Script Date: 2024-10-28 2:53:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetFoodItemsByRestaurant]
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