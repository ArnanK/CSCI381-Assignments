-- =============================================
-- Author: Dillon Chen
-- Create date: 12/2/2024
-- Description: Load Mode Of Instruction Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadModeOfInstruction]
GO

CREATE PROCEDURE [Project3].[LoadModeOfInstruction]
	@UserAuthorizationKey INT
AS 
BEGIN 
	
	INSERT INTO [Project3].[ModeOfInstruction]
	(ModeName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				C.[Mode of instruction] AS ModeName,
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
		)
	-- EXEC workflowsteps procedure
	EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Mode of Instruction Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- EXEC [LoadData].[LoadModeOfInstruction] @UserAuthorizationKey = 1
-- SELECT *
-- FROM [Project3].[ModeOfInstruction]
