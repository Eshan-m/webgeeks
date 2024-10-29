USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[GetFoodItems]    Script Date: 2024-10-28 2:59:01 PM ******/
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
