-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load ClassDetails Table
-- =============================================

USE QueensClassSchedule
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

DROP PROCEDURE IF EXISTS [Project3].[LoadClassDetails]
GO

CREATE PROCEDURE [Project3].[LoadClassDetails] 
    @UserAuthorizationKey INT
AS
BEGIN 

    INSERT INTO [Project3].[ClassDetails]
        ( 
            Code, [Limit], Enrolled, UserAuthorizationKey
        )
    (
        Select DISTINCT code,
        CASE 
            WHEN Limit < Enrolled THEN Enrolled
            ELSE LIMIT
        END AS [limit],
        Enrolled,
        @UserAuthorizationKey
        FROM UploadFile.CurrentSemesterCourseOfferings
    )
    
    PRINT 'done'
END 
GO



-- ========test code below for local env
-- EXEC [Project3].[LoadClassDetails] @UserAuthorizationKey=1
-- GO 

-- Select *
-- FROM [Project3].[ClassDetails]