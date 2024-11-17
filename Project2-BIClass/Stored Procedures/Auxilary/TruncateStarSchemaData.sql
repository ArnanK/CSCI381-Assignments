SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description:	Truncate Star Schema
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[TruncateStarSchemaData]
GO 

CREATE PROCEDURE [Project2].[TruncateStarSchemaData]
	@UserAuthorizationKey int
AS 
BEGIN 
	SET NOCOUNT ON
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	print 'insert your statements within the Begin\End block which is the equivalentof the Java { \ }'
END
GO

EXEC [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 1;
GO 


DECLARE TableCursor CURSOR FOR
SELECT DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'Base Table' AND TABLE_SCHEMA LIKE '%CH01%'

OPEN TableCursor
DECLARE @TableName NVARCHAR(255)
DECLARE @SQL VARCHAR(MAX)

FETCH NEXT FROM TableCursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @SQL = 'TRUNCATE TABLE ' + @TableName
	EXEC(@SQL)

	FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor

DEALLOCATE TableCursor

TRUNCATE TABLE [CH01-01-Dimension].[DimCustomer]

