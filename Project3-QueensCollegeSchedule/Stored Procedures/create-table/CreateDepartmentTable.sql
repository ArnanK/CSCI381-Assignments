-- =============================================
-- Author: Arnan Khan
-- Create date: 12/2/2024
-- Description: Load Department Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateDepartmentTable]
GO

CREATE PROCEDURE [Project3].[CreateDepartmentTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Department]
	CREATE TABLE [Project3].[Department]
		(
			DepartmentID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Department] DEFAULT (NEXT VALUE FOR [Project3].DepartmentID_Seq) PRIMARY KEY,
			[DeptName] [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Dept Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO
