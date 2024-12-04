-- =============================================
-- Author: Dillon Chen
-- Create date: 12/3/2024
-- Description: Create Course Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateCourseTable]
GO

CREATE PROCEDURE [Project3].[CreateCourseTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Course]
	CREATE TABLE [Project3].[Course]
		(
			CourseID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Course] DEFAULT (NEXT VALUE FOR [Project3].CourseID_Seq) PRIMARY KEY,
			CourseName [Udt].[P3NameString] NULL,
			CourseNum [Udt].[P3NameString] NULL,
            Semester [Udt].[P3NameString] NULL,
            DepartmentID INT NULL,
            Hours DECIMAL(5,2) NULL,
            Credits DECIMAL(5,2) NULL,
            WritingIntensive [Udt].[P3Bool] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Course Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO
