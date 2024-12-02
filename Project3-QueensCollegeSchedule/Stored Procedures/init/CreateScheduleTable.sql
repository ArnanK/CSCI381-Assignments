-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create Schedule Table
-- =============================================

USE QueensClassSchedule
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

DROP TABLE IF EXISTS [Project3].[Schedule]
DROP SEQUENCE IF EXISTS [Project3].[ScheduleID_Seq]
GO 

CREATE SEQUENCE [Project3].[ScheduleID_Seq]
AS INT
START WITH 0
INCREMENT BY 1
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateSchedule]
GO 

CREATE PROCEDURE [Project3].[CreateSchedule]
    @UserAuthorizationKey INT 
AS
BEGIN 
    DROP TABLE IF EXISTS [Project3].[Schedule]
    CREATE TABLE [Project3].[Schedule]
        (
            ScheduleID INT NOT NULL CONSTRAINT [Project3ScheduleSeq] DEFAULT (NEXT VALUE FOR [Project3].[ScheduleID_Seq]) PRIMARY KEY,
            [time] NVARCHAR(50),
            [day] NVARCHAR(50),
            UserAuthorizationKey INT NOT NULL
        )

END
GO 

EXEC [Project3].[CreateSchedule] @UserAuthorizationKey=1
Go
