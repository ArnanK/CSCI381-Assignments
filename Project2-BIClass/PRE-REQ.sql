SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description: Add foreign keys to star schema
-- =============================================
ALTER PROCEDURE [Project2].[AddForeignKeysToStarSchemaData]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PrimaryKey VARCHAR(255);
    DECLARE @SQL VARCHAR(MAX);
    DECLARE @FTableName VarChar(255);
    DECLARE @TableName VarChar(255);

    DECLARE PrimaryKeyCursor CURSOR FOR
    SELECT DISTINCT
        '[' + kcu.CONSTRAINT_SCHEMA + '].[' + kcu.TABLE_NAME + ']' AS fullqualifiedtablename,
        kcu.COLUMN_NAME AS primarykeycolumn,
        kcu.TABLE_NAME AS tablename
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
    WHERE TABLE_SCHEMA LIKE '%DIMENSION%' 
      AND CONSTRAINT_NAME LIKE '%PK%' 
      AND LOWER(TABLE_NAME) NOT LIKE '%category%';

    OPEN PrimaryKeyCursor;

    FETCH NEXT FROM PrimaryKeyCursor INTO  @FTableName, @PrimaryKey, @TableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE [CH01-01-Fact].[Data] ADD CONSTRAINT FK_' + @TableName + ' FOREIGN KEY (' + @PrimaryKey + ') REFERENCES ' + @FTableName + '(' + @PrimaryKey + ')';
        EXEC (@SQL);
        FETCH NEXT FROM PrimaryKeyCursor INTO @FTableName, @PrimaryKey, @TableName;
    END;

    CLOSE PrimaryKeyCursor;
    DEALLOCATE PrimaryKeyCursor;

    -- Manual Constraints for DimProduct Table
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD CONSTRAINT FK_DimProductSubcategory FOREIGN KEY(ProductSubcategoryKey)
    REFERENCES [CH01-01-Dimension].[DimProductSubcategory](ProductSubcategoryKey);

    ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]
    ADD CONSTRAINT FK_DimProductCategory FOREIGN KEY(ProductCategoryKey)
    REFERENCES [CH01-01-Dimension].[DimProductCategory](ProductCategoryKey);

END;
GO

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description: Add Primary Key Constraints
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_AddPkConstraint]
AS
BEGIN
    SET NOCOUNT ON;

    ALTER TABLE [CH01-01-Dimension].[DimCustomer] ADD CONSTRAINT PK_CustomerKey PRIMARY KEY(CustomerKey);
    ALTER TABLE [CH01-01-Dimension].[DimOccupation] ADD CONSTRAINT PK_OccupationKey PRIMARY KEY(OccupationKey);
    ALTER TABLE [CH01-01-Dimension].[DimProduct] ADD CONSTRAINT PK_ProductKey PRIMARY KEY(ProductKey);
    ALTER TABLE [CH01-01-Dimension].[DimTerritory] ADD CONSTRAINT PK_TerritoryKey PRIMARY KEY(TerritoryKey);
    ALTER TABLE [CH01-01-Dimension].[SalesManagers] ADD CONSTRAINT PK_SalesManagerKey PRIMARY KEY(SalesManagerKey);
    ALTER TABLE [CH01-01-Fact].[Data] ADD CONSTRAINT PK_SalesKey PRIMARY KEY(SalesKey);
END;
GO

-- =============================================
-- Author: Inderpreet Singh
-- Create date: 11/18/2024
-- Description: Show Table Status with Row Count (Modified for Reserved Keywords)
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[ShowTableStatusRowCount] 
@TableStatus VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimCustomer', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimCustomer;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimGender', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimGender;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimMaritalStatus', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimMaritalStatus;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimOccupation', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimOccupation;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimOrderDate', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimOrderDate;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimProduct', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimProduct;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimProductCategory', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimProductCategory;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimProductSubcategory', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimProductSubcategory;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.DimTerritory', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].DimTerritory;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Dimension.SalesManagers', [RowCount] = COUNT(*) 
    FROM [CH01-01-Dimension].SalesManagers;

    SELECT TableStatus = @TableStatus, TableName = 'CH01-01-Fact.Data', [RowCount] = COUNT(*) 
    FROM [CH01-01-Fact].Data;
END;
GO

-- =============================================
-- Author: Inderpreet Singh
-- Create date: 11/18/2024
-- Description: Create Sequence Objects (Modified for Conditional Checks)
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_CreateSO]
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'PKSequence')
    BEGIN
        EXEC('CREATE SCHEMA [PKSequence]');
    END;

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DataSequenceObject' AND type = 'SO')
    BEGIN
        CREATE SEQUENCE [PKSequence].[DataSequenceObject]
            AS INT
            START WITH 1
            INCREMENT BY 1
            MINVALUE 1
            MAXVALUE 2147483647
            NO CYCLE
            CACHE;
    END;

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DimCustomerSequenceObject' AND type = 'SO')
    BEGIN
        CREATE SEQUENCE [PKSequence].[DimCustomerSequenceObject]
            AS INT
            START WITH 1
            INCREMENT BY 1
            MINVALUE 1
            MAXVALUE 2147483647
            NO CYCLE
            CACHE;
    END;

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DimOccupationSequenceObject' AND type = 'SO')
    BEGIN
        CREATE SEQUENCE [PKSequence].[DimOccupationSequenceObject]
            AS INT
            START WITH 1
            INCREMENT BY 1
            MINVALUE 1
            MAXVALUE 2147483647
            NO CYCLE
            CACHE;
    END;

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DimProductSequenceObject' AND type = 'SO')
    BEGIN
        CREATE SEQUENCE [PKSequence].[DimProductSequenceObject]
            AS INT
            START WITH 1
            INCREMENT BY 1
            MINVALUE 1
            MAXVALUE 2147483647
            NO CYCLE
            CACHE;
    END;

    -- Other sequence creation statements follow the same pattern...
END;
GO

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description: Initialize Setup Procedure
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_InitSetup]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [Project2].[sp_CreateSO];
    EXEC [Project2].[sp_CreateTables];
    EXEC [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 2;
    EXEC [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 2;
    EXEC [Project2].[sp_DropPkConstraint];
    EXEC [Project2].[sp_DropColumns];
    EXEC [Project2].[sp_AddColumns];
    EXEC [Project2].[sp_AddPkConstraint];
    EXEC [Project2].[AddForeignKeysToStarSchemaData];
    EXEC [Project2].[sp_AddGroupMembers];
    EXEC [Project2].[ShowTableStatusRowCount] @TableStatus = 'Initialized';
END;
GO
