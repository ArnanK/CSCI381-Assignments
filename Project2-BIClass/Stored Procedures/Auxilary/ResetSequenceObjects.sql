SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Arnan Khan
-- Create date: 11/16/2024
-- Description:	Reset Sequence Objects to Lowest Key
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[ResetSequenceObjects]
GO 

CREATE PROCEDURE [Project2].[ResetSequenceObjects]
	@UserAuthorizationKey int
AS 
BEGIN 
	SET NOCOUNT ON
	DECLARE SequenceObjectCursor CURSOR FOR
	SELECT DISTINCT 
		'[' + schema_name(schema_id) + '].[' + [name] + ']' as SequenceObjectName
	FROM sys.sequences
	

	OPEN SequenceObjectCursor
	DECLARE @SequenceObjectName NVARCHAR(255)
	DECLARE @SQL VARCHAR(MAX)

	FETCH NEXT FROM SequenceObjectCursor INTO @SequenceObjectName

	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @SQL = 'ALTER SEQUENCE ' + @SequenceObjectName + ' RESTART WITH 1;'
		EXEC(@SQL)

		FETCH NEXT FROM SequenceObjectCursor INTO @SequenceObjectName
	END

	CLOSE SequenceObjectCursor

	DEALLOCATE SequenceObjectCursor

	EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Reset Sequence Objects.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO




