SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	 Drops the columns that utilize identity keys.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_DropColumns]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
 

    ALTER TABLE [CH01-01-Dimension].[DimCustomer] DROP COLUMN CustomerKey
    ALTER TABLE [CH01-01-Dimension].[DimOccupation] DROP COLUMN OccupationKey
    ALTER TABLE [CH01-01-Dimension].[DimProduct] DROP COLUMN ProductKey
    ALTER TABLE [CH01-01-Dimension].[DimTerritory] DROP COLUMN TerritoryKey
    ALTER TABLE [CH01-01-Dimension].[SalesManagers] DROP COLUMN SalesManagerKey
    ALTER TABLE [CH01-01-Fact].[Data] DROP COLUMN SalesKey



END;


GO
