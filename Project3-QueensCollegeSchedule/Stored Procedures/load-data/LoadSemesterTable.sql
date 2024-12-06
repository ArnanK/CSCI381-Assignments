-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/3/2024
-- Description: Load Semester Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


DROP PROCEDURE IF EXISTS [Project3].[LoadSemester]
GO

CREATE PROCEDURE [Project3].[LoadSemester]
    @UserAuthorizationKey INT
AS BEGIN
    DECLARE @RowCount INT;

    TRUNCATE TABLE [Project3].[Semester];

    INSERT INTO [Project3].[Semester] ([Name], UserAuthorizationKey)
    SELECT DISTINCT
        CASE
            WHEN DATALENGTH(o.semester) > 0 THEN o.semester
            ELSE 'UNKNOWN'
        END AS [Name],
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o;

    -- Get the row count
    SELECT @RowCount = COUNT(*) FROM [Project3].[Semester];

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Semester Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @RowCount;
END
GO

-- To execute the procedure:
-- EXEC [Project3].[LoadSemesterData] @UserAuthorizationKey = 1;
