-- =============================================
-- Author: Arnan Khan
-- Create date: 12/5/2024
-- Description: Create ClassSection Table
-- =============================================

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateClassSectionTable]
GO
CREATE PROCEDURE [Project3].[CreateClassSectionTable]
    @UserAuthorizationKey INT
AS 
BEGIN 
    DROP TABLE IF EXISTS [Project3].[ClassSection]
    CREATE TABLE [Project3].[ClassSection]
        (
            ClassSectionID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_ClassSection] DEFAULT (NEXT VALUE FOR [Project3].[ClassSectionID_Seq]) PRIMARY KEY,
            [InsturctorID] [Udt].[P3Key],
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
        @WorkFlowStepDescription = 'Create Class Details Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO 

GO

