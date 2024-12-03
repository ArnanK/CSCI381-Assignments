-- =============================================
-- Author: Dillon Chen
-- Create date: 12/2/2024
-- Description: Create Instructor Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateInstructorTable]
GO

CREATE PROCEDURE [Project3].[CreateInstructorTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Instructor]
	CREATE TABLE [Project3].[Instructor]
		(
			InstructorID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Instructor] DEFAULT (NEXT VALUE FOR [Project3].InstructorID_Seq) PRIMARY KEY,
			FirstName [Udt].[P3NameString] NULL,
			LastName [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Instructor Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO
