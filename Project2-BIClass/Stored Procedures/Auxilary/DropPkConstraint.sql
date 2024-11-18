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
	@UserAuthorizationKey int

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
        ('SalesManagers'),
        ('Data'),
        ('Fact');
      


    Declare @ConstraintName NVARCHAR(128), @TableName NVARCHAR(128), @SQL1 VARCHAR(MAX);

    DECLARE DropPkCursor CURSOR FOR 
    SELECT '['+kcu.TABLE_SCHEMA+'].['+kcu.TABLE_NAME+']' as [TableName], kcu.CONSTRAINT_NAME as [ConstrainName]
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    WHERE kcu.CONSTRAINT_NAME LIKE '%PK%' AND kcu.TABLE_NAME IN (SELECT * FROM @tables)
    


    
    Open DropPkCursor 
    FETCH NEXT FROM DropPkCursor INTO @TableName, @ConstraintName

    WHILE @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL1 = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + '['+@ConstraintName+']'+';'
		EXEC(@SQL1)
        FETCH NEXT FROM DropPkCursor INTO @TableName, @ConstraintName
    END
    
    CLOSE DropPkCursor
	DEALLOCATE DropPkCursor

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Drop PK Constraints.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;


GO
