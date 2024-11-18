SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description:	add foreign keys to star schema
-- =============================================
ALTER PROCEDURE [Project2].[AddForeignKeysToStarSchemaData]
	@UserAuthorizationKey int

AS
BEGIN
    SET NOCOUNT ON
    DECLARE @PrimaryKey VARCHAR(255)
    DECLARE @SQL VARCHAR(MAX)
    DECLARE @FTableName VarChar(255)
    DECLARE @TableName VarChar(255)

    DECLARE PrimaryKeyCursor CURSOR FOR

    SELECT DISTINCT
        '[' + kcu.CONSTRAINT_SCHEMA + '].[' + kcu.TABLE_NAME + ']' as fullqualifiedtablename,
        kcu.COLUMN_NAME as primarykeycolumn,
        kcu.TABLE_NAME as tablename
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    WHERE TABLE_SCHEMA LIKE '%DIMENSION%' AND CONSTRAINT_NAME LIKE '%PK%' AND LOWER(TABLE_NAME) NOT LIKE '%category%'

    OPEN PrimaryKeyCursor

    FETCH NEXT FROM PrimaryKeyCursor INTO  @FTableName, @PrimaryKey, @TableName

    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE [CH01-01-Fact].[Data] ADD CONSTRAINT FK_'+@TableName+' FOREIGN KEY (' + @PrimaryKey + ') REFERENCES ' + @FTableName + '(' + @PrimaryKey + ')'
        EXEC (@SQL)
        FETCH NEXT FROM PrimaryKeyCursor INTO @FTableName, @PrimaryKey, @TableName
    END

    CLOSE PrimaryKeyCursor
    DEALLOCATE PrimaryKeyCursor

    --Manual Constraints for DimProduct Table.
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD CONSTRAINT FK_DimProductSubcategory Foreign Key(ProductSubcategoryKey)
    REFERENCES [CH01-01-Dimension].[DimProductSubcategory](ProductSubcategoryKey)

    ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]
    ADD CONSTRAINT FK_DimProductCategory Foreign Key(ProductCategoryKey)
    REFERENCES [CH01-01-Dimension].[DimProductCategory](ProductCategoryKey)

    
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Add Foreign Keys.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;
GO


