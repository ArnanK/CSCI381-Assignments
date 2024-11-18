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
    DECLARE @tables TABLE (TableName NVARCHAR(128));
    INSERT INTO @tables (TableName)
    VALUES 
        ('DimCustomer'),
        ('DimGender'),
        ('DimMaritalStatus'),
        ('DimOccupation'),
        ('DimOrderDate'),
        ('DimProduct'),
        ('DimTerritory'),
        ('SalesManagers');

    --Convert Keys to Sequence Objects
    ALTER TABLE [CH01-01-Dimension].[DimCustomer]
    ADD CustomerKey INT NOT NULL CONSTRAINT DF_DimCustomer_Key DEFAULT (NEXT VALUE FOR [PKSequence].[DimCustomerSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    ADD OccupationKey INT NOT NULL CONSTRAINT DF_DimOccupation_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimOccupationSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD ProductKey INT NOT NULL CONSTRAINT DF_DimProduct_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimProductSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimTerritory]
    ADD TerritoryKey INT NOT NULL CONSTRAINT DF_DimTerritory_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimTerritorySequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimSalesManagers]
    ADD SalesManagersKey INT NOT NULL CONSTRAINT DF_DimSalesManagers_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimSalesManagersSequenceObject]);


    --Add User Authorization Key
    DECLARE @SQL2 NVARCHAR(MAX);
    -- Initialize the SQL string
    SET @SQL2 = '';
    SELECT @SQL2 = @SQL2 + 
        'ALTER TABLE [CH01-01-Dimension].[' + TableName + '] ADD [UserAuthorizationKey] [int] NOT NULL;' + CHAR(13)
    FROM @tables;
    EXEC sp_executesql @SQL2;

    
END;


GO
