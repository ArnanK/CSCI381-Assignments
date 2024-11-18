SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Nafisul Islam
-- Create date: 11/17/2024
-- Description: Loads data into the DimProduct table.
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProduct]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable

    -- Insert data into DimProduct table
    INSERT INTO [CH01-01-Dimension].[DimProduct] (
        ProductSubcategoryKey,
        ProductCategory,
        ProductSubcategory,
        ProductCode,
        ProductName,
        Color,
        ModelName,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        new.ProductSubcategoryKey,
        new.ProductCategory,
        new.ProductSubcategory,
        new.ProductCode,
        new.ProductName,
        new.Color,
        new.ModelName,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT
            dps.ProductSubcategoryKey,
            dpc.ProductCategory,
            dps.ProductSubcategory,
            ProductCode,
            ProductName,
            Color,
            ModelName
        FROM [FileUpload].OriginallyLoadedData AS old
        INNER JOIN [CH01-01-Dimension].[DimProductCategory] AS dpc ON old.ProductCategory = dpc.ProductCategory
        INNER JOIN [CH01-01-Dimension].[DimProductSubcategory] as dps ON old.ProductSubcategory = dps.ProductSubcategory
    ) AS new;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow] 
        @WorkFlowStepDescription = 'Loading data into the DimProduct Table',
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Use the variable in EXEC statement

END
GO
