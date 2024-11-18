SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Nafisul Islam
-- Create date: 11/17/2024
-- Description: Loads data into the DimProductCategory table.
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProductCategory]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable


    -- Insert data into DimProductCategory table
    INSERT INTO [CH01-01-Dimension].[DimProductCategory] (
        ProductCategory,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        new.ProductCategory,
        @UserAuthorizationKey
    FROM (

        SELECT DISTINCT
            old.ProductCategory
            FROM [FileUpload].OriginallyLoadedData AS old 
        )AS new;

    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow] 
        @WorkFlowStepDescription = 'Loading data into the DimProductSubcategory Table',
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Use the variable in EXEC statement

END
GO
