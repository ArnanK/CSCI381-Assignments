-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create Building Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateBuildingTable]
GO

CREATE PROCEDURE [Project3].[CreateBuildingTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Building]
	CREATE TABLE [Project3].[Building]
		(
			BuildingID INT NOT NULL CONSTRAINT [DF_BuildingID] DEFAULT (NEXT VALUE FOR BuildingID_Seq) PRIMARY KEY,
			BuildingName NVARCHAR(MAX) NULL,
			UserAuthorizationKey INT NULL
		)

	--EXEC trackworkflow procedure using userauthorizationkey
END
GO

-- EXEC [Project3].[CreateBuildingTable] @UserAuthorizationKey = 0 -- int
-- GO 

-- This select statement should produce a 
-- SELECT * 
-- FROM [Project3].[Building]




