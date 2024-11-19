-- =============================================
-- Author: Inderpreet Singh
-- Create date: 11/16/2024
-- Description: 
-- Loads data from the source table ([FileUpload].[OriginallyLoadedData]) 
-- into the Star Schema, including dimension and fact tables.
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[LoadStarSchema];
GO

CREATE PROCEDURE [Project2].[LoadStarSchema]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Load DimCustomer
    INSERT INTO [CH01-01-Dimension].[DimCustomer] 
    (CustomerName, MaritalStatus, Gender, Education, Occupation, UserAuthorizationKey)
    SELECT DISTINCT
        CustomerName, MaritalStatus, Gender, Education, Occupation, @UserAuthorizationKey
    FROM [FileUpload].[OriginallyLoadedData];

    -- Load DimProduct
    INSERT INTO [CH01-01-Dimension].[DimProduct] 
    (ProductSubcategoryKey, ProductCategory, ProductSubcategory, ProductCode, ProductName, Color, ModelName, UserAuthorizationKey)
    SELECT DISTINCT
        ProductSubcategoryKey, ProductCategory, ProductSubcategory, ProductCode, ProductName, Color, ModelName, @UserAuthorizationKey
    FROM [FileUpload].[OriginallyLoadedData];

    -- Load DimTerritory
    INSERT INTO [CH01-01-Dimension].[DimTerritory]
    (TerritoryRegion, TerritoryCountry, TerritoryGroup, UserAuthorizationKey)
    SELECT DISTINCT
        TerritoryRegion, TerritoryCountry, TerritoryGroup, @UserAuthorizationKey
    FROM [FileUpload].[OriginallyLoadedData];

    -- Load Fact.Data
    INSERT INTO [CH01-01-Fact].[Data]
    (SalesKey, SalesManagerKey, OccupationKey, TerritoryKey, ProductKey, CustomerKey, ProductCategory, SalesManager, ProductSubcategory,
     ProductCode, ProductName, Color, ModelName, OrderQuantity, UnitPrice, ProductStandardCost, SalesAmount, OrderDate, MonthName, [Year],
     CustomerName, MaritalStatus, Gender, Education, Occupation, TerritoryRegion, TerritoryCountry, TerritoryGroup)
    SELECT DISTINCT
        NEXT VALUE FOR [Process].[WorkFlowStepTableRowCountBy1],
        SalesManagerKey, OccupationKey, TerritoryKey, ProductKey, CustomerKey, ProductCategory, SalesManager, ProductSubcategory,
        ProductCode, ProductName, Color, ModelName, OrderQuantity, UnitPrice, ProductStandardCost, SalesAmount, OrderDate, MonthName, [Year],
        CustomerName, MaritalStatus, Gender, Education, Occupation, TerritoryRegion, TerritoryCountry, TerritoryGroup
    FROM [FileUpload].[OriginallyLoadedData];

    PRINT 'Star schema loading completed successfully.';
END;
GO
