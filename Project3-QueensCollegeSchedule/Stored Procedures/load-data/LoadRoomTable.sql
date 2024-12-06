SET ANSI_NULLS ON 
GO 

SET QUOTED_IDENTIFIER ON
GO 

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load Room Table
-- =============================================


DROP PROCEDURE IF EXISTS [Project3].[LoadRoom]
GO

CREATE PROCEDURE [Project3].[LoadRoom]
	@UserAuthorizationKey INT
AS
BEGIN

	INSERT INTO [Project3].[Room]
		(RoomNumber, UserAuthorizationKey)
	(
		SELECT DISTINCT
			CASE 
				WHEN DATALENGTH(Location) > 0 THEN SUBSTRING(Location, CHARINDEX(' ', Location, 0)+1, DATALENGTH(Location)-CHARINDEX(' ', Location, 0))
				ELSE 'Undecided'
			END AS RoomNum,
			@UserAuthorizationKey		
		FROM Uploadfile.CurrentSemesterCourseOfferings
	)

	PRINT 'Hello World'
END
GO 

-- EXEC [Project3].[LoadRoom] @UserAuthorizationKey = 1

-- SELECT * 
-- FROM [Project3].[Room]