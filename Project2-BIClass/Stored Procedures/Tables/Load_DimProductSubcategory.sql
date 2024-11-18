SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:    Nafisul Islam, debugged by:Inderpreet Singh
-- Create date: 11/17/2024
-- Description: Loads data into the DimProductSubcategory table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[Load_DimProductSubcategory]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable
    
    -- Insert the data from the FileUpload
    INSERT INTO [CH01-01-Dimension].[DimProductSubcategory] (
        ProductSubcategory,
        ProductCategoryKey,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        OLD.ProductSubcategory,
        OLD.ProductCategoryKey,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT d.ProductSubcategory, c.ProductCategoryKey
        FROM [FileUpload].OriginallyLoadedData d
        INNER JOIN [CH01-01-Dimension].DimProductCategory c ON d.ProductCategory = c.ProductCategory      
    ) AS OLD;

    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    EXEC [Process].[usp_TrackWorkFlow] 
        @WorkFlowStepDescription = 'Loading data into the DimProductSubcategory Table',
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;

END;
GO
