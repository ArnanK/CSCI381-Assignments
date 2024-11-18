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

    -- Insert data into DimProductCategory table
    INSERT INTO [CH01-01-Dimension].[DimProductCategory] (
        ProductSubcategoryKey,
        ProductCategory
    )
    SELECT DISTINCT
        NEXT VALUE FOR [Project2].[ProductCategorySequenceKey] AS ProductCategoryKey,
        new.ProductSubcategoryKey,
        new.ProductCategory
    FROM (
        SELECT DISTINCT
            old.ProductCategory,
            old.ProductSubcategory,
            dps.ProductSubcategoryKey
        FROM [FileUpload].OriginallyLoadedData AS old
        INNER JOIN [CH01-01-Dimension].[DimProductSubcategory] AS dps
        ON old.ProductSubcategory = dps.ProductSubcategory
    ) AS new;
END
GO
