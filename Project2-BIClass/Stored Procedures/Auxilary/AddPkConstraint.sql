SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	Add the PK Constraint.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_AddPkConstraint]
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
        ('DimOccupation'),
        ('DimProduct'),
        ('DimTerritory'),
        ('SalesManagers');


    Declare @Key NVARCHAR(128), @TableName NVARCHAR(128), @SQL1 VARCHAR(MAX);

    DECLARE AddPkCursor CURSOR FOR 
    SELECT '['+s.name+']' + '.'+ '['+t.name+']' AS TableName, c.name as [Key]
    FROM sys.tables t
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE  t.name IN (SELECT TableName FROM @tables) AND c.name LIKE '%Key%'

    
    Open AddPkCursor 
    FETCH NEXT FROM AddPkCursor INTO @TableName, @Key

    WHILE @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL1 =  'ALTER TABLE ' + @TableName + ' ADD CONSTRAINT PK_' + @Key + ' PRIMARY KEY (' + @Key + ');';
		EXEC(@SQL1)
        FETCH NEXT FROM AddPkCursor INTO @TableName, @Key
    END
    
    CLOSE AddPkCursor
	DEALLOCATE AddPkCursor



END;


GO
