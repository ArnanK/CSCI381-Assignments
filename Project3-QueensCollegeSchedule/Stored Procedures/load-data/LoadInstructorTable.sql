-- =============================================
-- Author: Dillon Chen | Edited By: Arnan Khan
-- Create date: 12/2/2024
-- Description: Load Instructor Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadInstructor]
GO

CREATE PROCEDURE [Project3].[LoadInstructor]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[Instructor]
	(FirstName, LastName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				SUBSTRING(C.Instructor, CHARINDEX(' ',C.Instructor,0)+1, LEN(C.Instructor) ), 
				SUBSTRING(C.Instructor, 0, CHARINDEX(',',C.Instructor,0)),
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Instructor Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO

