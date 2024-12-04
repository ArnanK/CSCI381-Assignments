-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/3/2024
-- Description: Create CourseMode Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[CreateCourseModeTable]
GO

CREATE PROCEDURE [Project3].[CreateCourseModeTable]
    @UserAuthorizationKey INT
AS 
BEGIN
    -- Drop the table if it already exists
    DROP TABLE IF EXISTS [Project3].[CourseMode]

    -- Create the CourseMode table
    CREATE TABLE [Project3].[CourseMode]
    (
        CourseModeID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_CourseModeID] DEFAULT (NEXT VALUE FOR [Project3].CourseModeID_Seq) PRIMARY KEY,
        CourseID [Udt].[P3Key] NOT NULL,
        ModeID [Udt].[P3Key] NOT NULL,
        UserAuthorizationKey INT NOT NULL,
        FOREIGN KEY (ModeID) REFERENCES [Project3].[ModeOfInstruction](ModeID)
    )

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create CourseMode Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

