-- =============================================
-- Author: Luis Diaz
-- Create date: 12/2/2024
-- Description: Create Semester Table Stored Procedure
-- =============================================


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateSemesterTable]
GO

CREATE PROCEDURE [Project3].[CreateSemesterTable]
    @UserAuthorizationKey INT
AS BEGIN
    DROP TABLE IF EXISTS [Project3].[Semester]
-- Create a new table
    CREATE TABLE [Project3].[Semester]
        (
        SemesterID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Semester] DEFAULT (NEXT VALUE FOR [Project3].[SemesterID_Seq]),
        [Name] Udt.[P3NameString],
        UserAuthorizationKey int
        );

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Semester Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO