-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load Building Table Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadBuildingData]
GO

CREATE PROCEDURE [Project3].[LoadBuildingData]
	@UserAuthorizationKey INT
AS 
BEGIN 
	
	TRUNCATE TABLE [Project3].[Building]

	INSERT INTO [Project3].[Building]
	(BuildingName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				CASE
					WHEN DATALENGTH(o.location) > 0 THEN SUBSTRING(o.location, 0, CHARINDEX(' ', o.location, 0))
					ELSE 'UNKNOWN'
				END AS buildingname,
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS o
		)
	-- EXEC workflowsteps procedure
END
GO

-- EXEC [LoadData].[LoadBuildingData] @UserAuthorizationKey = 1
-- SELECT *
-- FROM [Project3].[Building]
