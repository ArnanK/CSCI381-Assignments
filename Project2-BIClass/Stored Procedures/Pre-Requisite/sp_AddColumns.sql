SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	Adds all the required columns with the default.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_AddColumns]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
 
    -- List of tables where the column needs to be added
    DECLARE @TableName VARCHAR(500), @SQL VARCHAR(MAX);
    DECLARE AddCursor CURSOR FOR

    SELECT DISTINCT
        '[' + t.TABLE_SCHEMA + '].[' + t.TABLE_NAME + ']' as fullqualifiedtablename
    FROM INFORMATION_SCHEMA.Tables as t
    WHERE TABLE_SCHEMA LIKE '%CH1%'

    OPEN AddCursor

    FETCH NEXT FROM AddCursor INTO  @TableName

    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE ' + @TableName + + 'ADD [UserAuthorizationKey] [int] NOT NULL;'
        EXEC (@SQL)
        FETCH NEXT FROM AddCursor INTO @TableName
    END

    CLOSE AddCursor
    DEALLOCATE AddCursor


    --Convert Keys to Sequence Objects
    ALTER TABLE [CH01-01-Dimension].[DimCustomer]
    ADD CustomerKey INT NOT NULL CONSTRAINT DF_DimCustomer_Key DEFAULT (NEXT VALUE FOR [PKSequence].[DimCustomerSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    ADD OccupationKey INT NOT NULL CONSTRAINT DF_DimOccupation_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimOccupationSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD ProductKey INT NOT NULL CONSTRAINT DF_DimProduct_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimProductSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimTerritory]
    ADD TerritoryKey INT NOT NULL CONSTRAINT DF_DimTerritory_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimTerritorySequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[SalesManagers]
    ADD SalesManagerKey INT NOT NULL CONSTRAINT DF_SalesManager_Key DEFAULT(NEXT VALUE FOR [PKSequence].[SalesManagersSequenceObject]);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD SalesKey INT NOT NULL CONSTRAINT DF_Sales_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DataSequenceObject]);
    


    
END;


GO
