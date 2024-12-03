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


DROP PROCEDURE IF EXISTS [Project3].[CreateScheduleTable]
GO 

CREATE PROCEDURE [Project3].[CreateScheduleTable]
    @UserAuthorizationKey INT 
AS
BEGIN 
    DROP TABLE IF EXISTS [Project3].[Schedule]
    CREATE TABLE [Project3].[Schedule]
        (
            ScheduleID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Schedule] DEFAULT (NEXT VALUE FOR [Project3].[ScheduleID_Seq]) PRIMARY KEY,
            [time] [Udt].[P3Time],
            [day] [Udt].[P3Day],
            UserAuthorizationKey INT NOT NULL
        )

END
GO 

--EXEC [Project3].[CreateSchedule] @UserAuthorizationKey=1
Go
