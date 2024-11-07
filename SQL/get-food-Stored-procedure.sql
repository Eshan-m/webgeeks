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
