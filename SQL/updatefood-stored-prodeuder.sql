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
