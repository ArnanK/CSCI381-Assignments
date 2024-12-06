-- =============================================
-- Author: Arnan Khan
-- Create date: 12/5/2024
-- Description: Create ClassSection Table
-- =============================================

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateClassTable]
GO
CREATE PROCEDURE [Project3].[CreateClassTable]
    @UserAuthorizationKey INT
AS 
BEGIN 
    DROP TABLE IF EXISTS [Project3].[Class]
    CREATE TABLE [Project3].[Class]
        (
            ClassID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Class] DEFAULT (NEXT VALUE FOR [Project3].[ClassID_Seq]) PRIMARY KEY,
            [InstructorID] [Udt].[P3Key],
            [ScheduleID] [Udt].[P3Key],
            [SemesterID] [Udt].[P3Key],
            [RoomBuildingID] [Udt].[P3Key],
            [CourseID] [Udt].[P3Key],
            [ModeOfInstructionID] [Udt].[P3Key],
            [SectionID] [Udt].[P3Key],
            [ClassDetailsID] [Udt].[P3Key],
            UserAuthorizationKey INT  NULL
        )
    
    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Class Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO 

GO

