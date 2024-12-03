-- =============================================
-- Author: Arnan Khan
-- Create date: 12/3/2024
-- Description: Load InstructorDept Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadInstructorDept]
GO

CREATE PROCEDURE [Project3].[LoadInstructorDept]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[InstructorDept]
	(InstructorID,DepartmentID,UserAuthorizationKey)
		(   
            SELECT  
                    DISTINCT 
                    I.InstructorID,
                    D.DepartmentID,
                    @UserAuthorizationKey
            FROM Uploadfile.CurrentSemesterCourseOfferings c
            INNER JOIN Project3.Instructor I on CONCAT(SUBSTRING(C.Instructor, CHARINDEX(' ',C.Instructor,0)+1, LEN(C.Instructor) ), SUBSTRING(C.Instructor, 0, CHARINDEX(',',C.Instructor,0))) = CONCAT(I.FirstName,I.LastName)
            INNER JOIN Project3.Department D on SUBSTRING(C.[Course (hr, crd)],0,CHARINDEX(' ',C.[Course (hr, crd)], 0))=D.DeptName
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load InstructorDept Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO

