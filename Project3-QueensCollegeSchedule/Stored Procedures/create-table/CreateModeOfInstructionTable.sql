-- =============================================
-- Author: Dillon Chen
-- Create date: 12/2/2024
-- Description: Create Mode Of Instruction Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateModeOfInstructionTable]
GO

CREATE PROCEDURE [Project3].[CreateModeOfInstructionTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[ModeOfInstruction]
	CREATE TABLE [Project3].[ModeOfInstruction]
		(
			ModeOfInstructionID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_ModeOfInstruction] DEFAULT (NEXT VALUE FOR [Project3].ModeOfInstructionID_Seq) PRIMARY KEY,
			ModeName [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Mode of Instruction Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO
