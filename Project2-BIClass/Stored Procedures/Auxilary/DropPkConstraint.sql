SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	Drops the PK Constraint.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_DropPkConstraint]
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


    Declare @ConstraintName NVARCHAR(128), @TableName NVARCHAR(128), @SQL1 VARCHAR(MAX);

    DECLARE DropPkCursor CURSOR FOR 
    SELECT '['+s.name+']' + '.'+ '['+t.name+']' AS TableName, kc.name AS ConstraintName
    FROM sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.key_constraints kc ON t.object_id = kc.parent_object_id
    WHERE kc.type = 'PK'  AND t.name IN (SELECT TableName FROM @tables)

    
    Open DropPkCursor 
    FETCH NEXT FROM DropPkCursor INTO @TableName, @ConstraintName

    WHILE @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL1 = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT' + '['+@ConstraintName+']'+';'
		EXEC(@SQL1)
        FETCH NEXT FROM DropPkCursor INTO @TableName, @ConstraintName
    END
    
    CLOSE DropPkCursor
	DEALLOCATE DropPkCursor



END;


GO
