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
			InstructorID INT NOT NULL CONSTRAINT [DF_InstructorID] DEFAULT (NEXT VALUE FOR InstructorID_Seq) PRIMARY KEY,
			InstructorName NVARCHAR(MAX) NULL,
			UserAuthorizationKey INT NULL
		)

	--EXEC trackworkflow procedure using userauthorizationkey
END
GO

-- EXEC [Project3].[CreateInstructorTable] @UserAuthorizationKey = 0 -- int
-- GO 

-- This select statement should produce a 
-- SELECT * 
-- FROM [Project3].[Instructor]
