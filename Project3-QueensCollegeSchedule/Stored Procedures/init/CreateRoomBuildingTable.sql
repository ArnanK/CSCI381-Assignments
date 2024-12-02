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

    -- Drop and create the sequence for RoomBuildingID
    DROP SEQUENCE IF EXISTS [Project3].[RoomBuildingID_Seq]
    CREATE SEQUENCE [Project3].[RoomBuildingID_Seq] AS INT
    START WITH 1
    INCREMENT BY 1

    -- Create the RoomBuilding bridge table
    CREATE TABLE [Project3].[RoomBuilding]
    (
        RoomBuildingID INT NOT NULL CONSTRAINT [Project3RoomBuildingSeq] DEFAULT (NEXT VALUE FOR [Project3].[RoomBuildingID_Seq]) PRIMARY KEY,
        RoomID INT NOT NULL,
        BuildingID INT NOT NULL,
        UserAuthorizationKey INT NOT NULL,
        FOREIGN KEY (RoomID) REFERENCES [Project3].[Room](RoomID),
        FOREIGN KEY (BuildingID) REFERENCES [Project3].[Building](BuildingID)
    )

    -- Call workflow tracking procedure
    -- EXEC [Process].[usp_TrackWorkFlow] @StartTime, 'CreateRoomBuildingTable', 0, @UserAuthorizationKey
END
GO


EXEC [Project3].[CreateRoomBuildingTable]
