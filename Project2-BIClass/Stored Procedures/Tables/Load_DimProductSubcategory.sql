SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Nafisul Islam
-- Create date: 11/17/2024
-- Description: Loads data into the DimProductSubcategory table.
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProductSubcategory]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert the data from the FileUpload
    INSERT INTO [CH01-01-Dimension].[DimProductSubcategory] (
        ProductSubcategory
    )
    SELECT DISTINCT
        NEXT VALUE FOR [Project2].[ProductCategorySubcategorySequenceKey] AS ProductSubcategoryKey,
        OLD.ProductSubcategory
    FROM (
        SELECT DISTINCT ProductSubcategory
        FROM [FileUpload].OriginallyLoadedData
    ) AS OLD;
END;
GO