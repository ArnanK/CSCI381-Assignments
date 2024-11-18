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
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @PrimaryKey VARCHAR(255)
    DECLARE @SQL VARCHAR(MAX)
    DECLARE @TableName VarChar(255)

    DECLARE PrimaryKeyCursor CURSOR FOR

    SELECT DISTINCT
        '[' + kcu.CONSTRAINT_SCHEMA + '].[' + kcu.TABLE_NAME + ']' as fullqualifiedtablename,
        kcu.COLUMN_NAME as primarykeycolumn
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    WHERE TABLE_SCHEMA LIKE '%DIMENSION%' AND CONSTRAINT_NAME LIKE '%PK%'

    OPEN PrimaryKeyCursor

    FETCH NEXT FROM PrimaryKeyCursor INTO  @TableName, @PrimaryKey

    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE [CH01-01-Fact].[Data] ADD FOREIGN KEY (' + @PrimaryKey + ') REFERENCES ' + @TableName + '(' + @PrimaryKey + ')'
        EXEC (@SQL)
        FETCH NEXT FROM PrimaryKeyCursor INTO @TableName, @PrimaryKey
    END

    CLOSE PrimaryKeyCursor
    DEALLOCATE PrimaryKeyCursor
END;
GO