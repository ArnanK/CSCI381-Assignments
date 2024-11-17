SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	
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
    exec [Project2].[TruncateStarSchemaData] @GroupMemberUserAuthorizationKey = -1
    exec [Project2].[DropForeignKeysFromStarSchemaData]
    

    --Convert Keys to Sequence Objects
    ALTER TABLE [CH01-01-Dimension].[DimCustomer]
    DROP COLUMN [CustomerKey];
    ALTER TABLE [CH01-01-Dimension].[DimCustomer]
    ADD CustomerKey INT NOT NULL CONSTRAINT DF_DimCustomer_Key DEFAULT (NEXT VALUE FOR [PKSequence].[DimCustomerSequenceObject]);

    ALTER TABLE [CH01-01-Dimension].[DimGender]
    ADD GenderKey INT NOT NULL CONSTRAINT DF_DimGender_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimGenderSequenceObject]);

    ALTER TABLE [CH01-01-Dimension].[DimMaritalStatus]
    ADD MaritalStatusKey INT NOT NULL CONSTRAINT DF_DimMaritalStatus_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimMaritalStatusSequenceObject]);

    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    DROP COLUMN [OccupationKey]; 
    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    ADD OccupationKey INT NOT NULL CONSTRAINT DF_DimOccupation_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimOccupationSequenceObject]);

    ALTER TABLE [CH01-01-Dimension].[DimOrderDate]
    ADD OrderDateKey INT NOT NULL CONSTRAINT DF_DimOrderDate_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimOrderDateSequenceObject]);

    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    DROP COLUMN [ProductKey];
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD ProductKey INT NOT NULL CONSTRAINT DF_DimProduct_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimProductSequenceObject]);

    ALTER TABLE [CH01-01-Dimension].[DimTerritory]
    DROP COLUMN [TerritoryKey];
    ALTER TABLE [CH01-01-Dimension].[DimTerritory]
    ADD TerritoryKey INT NOT NULL CONSTRAINT DF_DimTerritory_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimTerritorySequenceObject]);

    ALTER TABLE [CH01-01-Dimension].[SalesManagers]
    DROP COLUMN [SalesManagersKey];
    ALTER TABLE [CH01-01-Dimension].[DimSalesManagers]
    ADD SalesManagersKey INT NOT NULL CONSTRAINT DF_DimSalesManagers_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimSalesManagersSequenceObject]);


    --Add User Authorization Key
    ALTER TABLE [CH01-01-Dimension].[DimCustomer]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    ALTER TABLE [CH01-01-Dimension].[DimGender]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    ALTER TABLE [CH01-01-Dimension].[DimMaritalStatus]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    ALTER TABLE [CH01-01-Dimension].[DimOrderDate]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    ALTER TABLE [CH01-01-Dimension].[DimTerritory]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    ALTER TABLE [CH01-01-Dimension].[SalesManagers]
    ADD [UserAuthorizationKey] [int] NOT NULL;

    exec [Project2].[AddForeignKeysToStarSchemaData]

END;


GO
