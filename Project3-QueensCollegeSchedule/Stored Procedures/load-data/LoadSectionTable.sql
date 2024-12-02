-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/2/2024
-- Description: Load Section Table Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[LoadSectionData]
GO

CREATE PROCEDURE [Project3].[LoadSectionData]
    @UserAuthorizationKey INT
AS 
BEGIN 
    -- Truncate the Section table to remove old data
    TRUNCATE TABLE [Project3].[Section]

    -- Insert distinct data into the Section table
    INSERT INTO [Project3].[Section]
    (SectionName, UserAuthorizationKey)
    SELECT DISTINCT
        CASE
            WHEN DATALENGTH(o.section) > 0 THEN o.section
            ELSE 'UNKNOWN'
        END AS SectionName,
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o
    
    -- Call the workflow steps procedure to track this operation
    -- EXEC [Process].[usp_TrackWorkFlow] @StartTime, 'LoadSectionData', (SELECT COUNT(*) FROM [Project3].[Section]), @UserAuthorizationKey
END
GO


-- Testing the procedure with an example authorization key
-- EXEC [Project3].[LoadSectionData] @UserAuthorizationKey = 1
-- SELECT * FROM [Project3].[Section]