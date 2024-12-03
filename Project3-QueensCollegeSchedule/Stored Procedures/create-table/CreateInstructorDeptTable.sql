-- =============================================
-- Author: Arnan Khan
-- Create date: 12/2/2024
-- Description: Load InstructorDept Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateInstructorDeptTable]
GO

CREATE PROCEDURE [Project3].[CreateInstructorDeptTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[InstructorDept]
	CREATE TABLE [Project3].[InstructorDept]
		(
			InstructorDeptID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_InstructorDept] DEFAULT (NEXT VALUE FOR [Project3].InstructorDeptID_Seq) PRIMARY KEY,
			[InstructorID] [Udt].[P3Key] NULL,
            [DepartmentID] [Udt].[P3Key] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create InstructorDept Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO
