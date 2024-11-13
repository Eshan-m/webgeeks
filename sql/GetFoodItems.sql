/* GetFoodItems.sql */

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
END;
GO

