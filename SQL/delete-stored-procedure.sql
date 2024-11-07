USE [DevTest]
GO
/****** Object:  StoredProcedure [dbo].[DeleteFoodItemById] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFoodItemById]
    @foodItemId INT  
AS
BEGIN
    DELETE FROM fooditems
    WHERE id = @foodItemId;
END;
GO
