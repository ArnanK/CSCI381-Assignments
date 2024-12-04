-- =============================================
-- Author: Dillon Chen
-- Create date: 12/3/2024
-- Description: Load Course Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadCourse]
GO

CREATE PROCEDURE [Project3].[LoadCourse]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[Course]
	(CourseName, CourseNum, SemesterID, DepartmentID, Hours, Credits, WritingIntensive, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				SUBSTRING(C1.[Course (hr, crd)], 0, CHARINDEX(' ', C1.[Course (hr, crd)])),
                SUBSTRING(C1.[Course (hr, crd)], CHARINDEX(' ', C1.[Course (hr, crd)]), CHARINDEX('(', C1.[Course (hr, crd)]) - CHARINDEX(' ', C1.[Course (hr, crd)])-1),
                C1.Semester,
                1234, --Replace with DepartmentID
                CAST(SUBSTRING(C1.[Course (hr, crd)], CHARINDEX('(', C1.[Course (hr, crd)])+1, CHARINDEX(',', C1.[Course (hr, crd)]) - CHARINDEX('(', C1.[Course (hr, crd)])-1) AS DECIMAL(5,2)),
                CAST(SUBSTRING(C1.[Course (hr, crd)], CHARINDEX(',', C1.[Course (hr, crd)])+1, CHARINDEX(')', C1.[Course (hr, crd)]) - CHARINDEX(',', C1.[Course (hr, crd)])-1) AS DECIMAL(5,2)),
                (CASE
                    WHEN C1.[Course (hr, crd)] LIKE N'%[0-9]%W%' THEN 1
                    ELSE 0
                 END),
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C1
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Course Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO

