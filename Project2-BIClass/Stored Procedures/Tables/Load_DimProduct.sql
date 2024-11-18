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

    -- Insert data into DimProduct table
    INSERT INTO [CH01-01-Dimension].[DimProduct] (
        ProductCategoryKey,
        ProductCode,
        ProductName,
        Color,
        ModelName
    )
    SELECT DISTINCT
        NEXT VALUE FOR [Project2].[DimProductSequenceKey] AS ProductKey,
        new.ProductCategoryKey,
        new.ProductCode,
        new.ProductName,
        new.Color,
        new.ModelName
    FROM (
        SELECT DISTINCT
            ProductCategoryKey,
            ProductCode,
            ProductName,
            Color,
            ModelName
        FROM [FileUpload].OriginallyLoadedData AS old
        INNER JOIN [CH01-01-Dimension].[DimProductCategory] AS dpc
        ON old.ProductCategory = dpc.ProductCategory
    ) AS new;
END
GO
