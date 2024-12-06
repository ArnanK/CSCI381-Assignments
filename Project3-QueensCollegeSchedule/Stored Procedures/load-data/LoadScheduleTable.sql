-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load Schedule Table
-- =============================================
USE QueensClassSchedule
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadSchedule]
GO

CREATE PROCEDURE [Project3].[LoadSchedule]
    @UserAuthorizationKey INT 
AS
BEGIN
    INSERT INTO [Project3].[Schedule]
        (
            [time],[day],UserAuthorizationKey
        )
    SELECT 
        CASE
            WHEN DATALENGTH(o.time) > 2 THEN o.time
            ELSE 'NA'
        END AS [time],
        CASE
            WHEN DATALENGTH(o.[Day]) > 1  THEN o.day 
            ELSE 'NA'
        END AS [day],
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings as o
    Print 'done'
END
GO 

