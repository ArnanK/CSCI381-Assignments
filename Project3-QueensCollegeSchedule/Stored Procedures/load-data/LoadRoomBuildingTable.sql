-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/2/2024
-- Description: Load RoomBuilding Bridge Table
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[LoadRoomBuilding]
GO

CREATE PROCEDURE [Project3].[LoadRoomBuilding]
    @UserAuthorizationKey INT
AS
BEGIN
    -- Truncate the RoomBuilding table to remove old data

    -- Insert data into RoomBuilding by matching Room and Building
    INSERT INTO [Project3].[RoomBuilding] (RoomID, BuildingID, UserAuthorizationKey)
    SELECT DISTINCT
        r.RoomID,
        b.BuildingID,
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o
    INNER JOIN [Project3].[Building] AS b ON
        b.BuildingName = CASE
            WHEN DATALENGTH(o.location) > 0 THEN SUBSTRING(o.location, 0, CHARINDEX(' ', o.location))
            ELSE 'UNKNOWN'
        END
    INNER JOIN [Project3].[Room] AS r ON
        r.RoomNumber = CASE
            WHEN DATALENGTH(o.location) > 0 THEN SUBSTRING(o.location, CHARINDEX(' ', o.location) + 1, LEN(o.location))
            ELSE 'UNKNOWN'
        END

    -- Optional: Call workflow tracking procedure
    -- EXEC [Process].[usp_TrackWorkFlow] @StartTime, 'LoadRoomBuildingData', (SELECT COUNT(*) FROM [Project3].[RoomBuilding]), @UserAuthorizationKey
END
GO


-- EXEC [Project3].[LoadRoomBuildingData] @UserAuthorizationKey = 1
