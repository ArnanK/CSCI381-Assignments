-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create ClassDetails Table
-- =============================================

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateClassDetailsTable]
GO
CREATE PROCEDURE [Project3].[CreateClassDetailsTable]
    @UserAuthorizationKey INT
AS 
BEGIN 
    DROP TABLE IF EXISTS [Project3].[ClassDetails]
    CREATE TABLE [Project3].[ClassDetails]
        (
            ClassDetailsID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_ClassDetails] DEFAULT (NEXT VALUE FOR [Project3].[ClassDetailsID_Seq]) PRIMARY KEY,
            Code [Udt].[P3Int] NOT NULL,
            [Limit] [Udt].[P3Int],
            [Enrolled] [Udt].[P3Int],
            UserAuthorizationKey INT NOT NULL
        )
    
    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Class Details Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO 

GO

