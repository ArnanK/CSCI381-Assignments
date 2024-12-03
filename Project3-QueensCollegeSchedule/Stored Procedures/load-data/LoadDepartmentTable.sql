-- =============================================
-- Author: Arnan Khan
-- Create date: 12/3/2024
-- Description: Load Department Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadDepartment]
GO

CREATE PROCEDURE [Project3].[LoadDepartment]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[Department]
	(DeptName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				SUBSTRING(C.[Course (hr, crd)],0,CHARINDEX(' ',C.[Course (hr, crd)], 0)),
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Department Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO

