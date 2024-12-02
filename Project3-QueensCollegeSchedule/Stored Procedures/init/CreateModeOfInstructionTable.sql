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
			ModeID INT NOT NULL CONSTRAINT [DF_ModeID] DEFAULT (NEXT VALUE FOR ModeID_Seq) PRIMARY KEY,
			ModeName NVARCHAR(MAX) NULL,
			UserAuthorizationKey INT NULL
		)

	--EXEC trackworkflow procedure using userauthorizationkey
END
GO

-- EXEC [Project3].[CreateModeOfInstructionTable] @UserAuthorizationKey = 0 -- int
-- GO 

-- This select statement should produce a 
-- SELECT * 
-- FROM [Project3].[ModeOfInstruction]
