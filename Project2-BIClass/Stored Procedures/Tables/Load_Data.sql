SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Dillon Chen/Debugged by: Inderpreet Singh
-- Create date: 11/18/2024
-- Description: Inserts all data into one Fact.Data table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[Load_Data]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT;

    -- Insert data into Fact.Data table
    INSERT INTO [CH01-01-Fact].[Data]
    (
        SalesKey,
        SalesManagerKey,
        OccupationKey,
        TerritoryKey,
        ProductKey,
        CustomerKey,
        ProductCategory,
        SalesManager,
        ProductSubcategory,
        ProductCode,
        ProductName,
        Color,
        ModelName,
        OrderQuantity,
        UnitPrice,
        ProductStandardCost,
        SalesAmount,
        OrderDate,
        MonthName,
        [Year],
        CustomerName,
        MaritalStatus,
        Gender,
        Education,
        Occupation,
        TerritoryRegion,
        TerritoryCountry,
        TerritoryGroup
    )
    SELECT
        NEXT VALUE FOR [Project2].[DataSequenceKey],
        SM.SalesManagerKey,
        DO.OccupationKey,
        DT.TerritoryKey,
        DP.ProductKey,
        DC.CustomerKey,
        OLD.ProductCategory,
        OLD.SalesManager,
        OLD.ProductSubcategory,
        OLD.ProductCode,
        OLD.ProductName,
        OLD.Color,
        OLD.ModelName,
        OLD.OrderQuantity,
        OLD.UnitPrice,
        OLD.ProductStandardCost,
        OLD.SalesAmount,
        OLD.OrderDate,
        OLD.MonthName,
        OLD.[Year],
        OLD.CustomerName,
        OLD.MaritalStatus,
        OLD.Gender,
        OLD.Education,
        OLD.Occupation,
        OLD.TerritoryRegion,
        OLD.TerritoryCountry,
        OLD.TerritoryGroup
    FROM FileUpload.OriginallyLoadedData AS OLD
    INNER JOIN [CH01-01-Dimension].[SalesManagers] AS SM
        ON SM.SalesManager = OLD.SalesManager
    INNER JOIN [CH01-01-Dimension].[DimOccupation] AS DO
        ON DO.Occupation = OLD.Occupation
    INNER JOIN [CH01-01-Dimension].[DimTerritory] AS DT
        ON DT.TerritoryGroup = OLD.TerritoryGroup
        AND DT.TerritoryCountry = OLD.TerritoryCountry
        AND DT.TerritoryRegion = OLD.TerritoryRegion
    INNER JOIN [CH01-01-Dimension].[DimProduct] AS DP
        ON DP.ProductName = OLD.ProductName
    INNER JOIN [CH01-01-Dimension].[DimCustomer] AS DC
        ON DC.CustomerName = OLD.CustomerName;

    -- Get the row count
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loaded all data into Fact.Data table',
        @GroupMemberUserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO
