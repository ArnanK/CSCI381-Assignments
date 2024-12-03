-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/2/2024
-- Description: Create RoomBuilding Bridge Table
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[CreateRoomBuildingTable]
GO

CREATE PROCEDURE [Project3].[CreateRoomBuildingTable]
     @UserAuthorizationKey INT 
AS
BEGIN
    -- Drop the table if it already exists
    DROP TABLE IF EXISTS [Project3].[RoomBuilding]


    -- Create the RoomBuilding bridge table
    CREATE TABLE [Project3].[RoomBuilding]
    (
        RoomBuildingID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_RoomBuilding] DEFAULT (NEXT VALUE FOR [Project3].[RoomBuildingID_Seq]) PRIMARY KEY,
        RoomID [Udt].[P3Key] NOT NULL,
        BuildingID [Udt].[P3Key] NOT NULL,
        UserAuthorizationKey INT NOT NULL,
    )

    -- Call workflow tracking procedure
    -- EXEC [Process].[usp_TrackWorkFlow] @StartTime, 'CreateRoomBuildingTable', 0, @UserAuthorizationKey
END
GO


--EXEC [Project3].[CreateRoomBuildingTable]
