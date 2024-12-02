-- =============================================
-- Author: Dillon Chen
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
	
	TRUNCATE TABLE [Project3].[Instructor]

	INSERT INTO [Project3].[Instructor]
	(InstructorName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				C.Instructor AS InstructorName,
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
		)
	-- EXEC workflowsteps procedure
END
GO

-- EXEC [LoadData].[LoadInstructor] @UserAuthorizationKey = 1
-- SELECT *
-- FROM [Project3].[Instructor]
