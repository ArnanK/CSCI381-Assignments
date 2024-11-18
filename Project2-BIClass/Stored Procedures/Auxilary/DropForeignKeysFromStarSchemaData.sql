SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Benjamin
-- Create date: 
-- Description:	Drop the Foreign Keys From the Star Schema
-- =============================================
-- GRANT DROP ON  ON SCHEMA:CH01-01-Fact TO sa

DROP PROCEDURE IF EXISTS [Project2].[DropForeignKeysFromStarSchemaData]
GO

CREATE PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    Declare @ForeignKeyName VARCHAR(255)
    DECLARE @SQL VARCHAR(MAX)
    DECLARE @TableName VARCHAR(255)
    DECLARE ForeignKeyCursor CURSOR FOR 
    
    SELECT fk.name as ForeignKeyName,
        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.Data' as TableName
    FROM sys.foreign_keys as fk
    INNER JOIN sys.tables as t on fk.parent_object_id = t.object_id

    OPEN ForeignKeyCursor

    FETCH NEXT FROM ForeignKeyCursor INTO @ForeignKeyName, @TableName

    WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT IF EXISTS ' + @ForeignKeyName + ';'
        EXEC(@SQL)
        
        FETCH NEXT FROM ForeignKeyCursor INTO @ForeignKeyName, @TableName
    END

    CLOSE ForeignKeyCursor
    DEALLOCATE ForeignKeyCursor

    --Manual Process for Dim.Product Table
    ALTER TABLE [CH01-01-Dimension].[DimProduct] DROP CONSTRAINT IF EXISTS FK_DimProductSubcategory;
    ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] DROP CONSTRAINT IF EXISTS FK_DimProductCategory;


END;
GO
