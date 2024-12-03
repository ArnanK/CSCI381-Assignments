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
			BuildingID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Building] DEFAULT (NEXT VALUE FOR [Project3].BuildingID_Seq) PRIMARY KEY,
			BuildingName [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Building Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO






